#!/usr/bin/env python3

"""
JSON object merge tool.
Based on mergedeep and Python3 JSON Stream State Machine.
References:
https://github.com/clarketm/mergedeep
https://stackoverflow.com/a/47638751
"""

import argparse
import collections
import copy
import enum
import functools
import json
import logging
import math
import sys
import typing


formatter = logging.Formatter('%(asctime)s, %(levelname)s %(message)s')

ch = logging.StreamHandler()
ch.setFormatter(formatter)
logger = logging.getLogger(__name__)
logger.addHandler(ch)
logger.setLevel(logging.INFO)


class Strategy(enum.Enum):
    """DeepMerge strategy enums."""

    # Replace `destination` item with one from `source` (default).
    REPLACE = 0

    # Combine `list`, `tuple`, `set`, or `Counter` types into one collection.
    ADDITIVE = 1

    # Alias to: `TYPESAFE_REPLACE`
    TYPESAFE = 2

    # Raise `TypeError` when `destination` and `source` types differ. Otherwise, perform a `REPLACE` merge.
    TYPESAFE_REPLACE = 3

    # Raise `TypeError` when `destination` and `source` types differ. Otherwise, perform a `ADDITIVE` merge.
    TYPESAFE_ADDITIVE = 4


class DeepMerge():
    """
    Originally based on deepmerge.  This is essentially a class-ified version.
    See: https://github.com/clarketm/mergedeep
    """

    @staticmethod
    def _handle_merge_replace(destination, source, key):
        if isinstance(destination[key], collections.Counter) and isinstance(source[key], collections.Counter):
            # Merge both destination and source `Counter` as if they were a standard dict.
            DeepMerge._deepmerge(destination[key], source[key])
        else:
            # If a key exists in both objects and the values are `different`, the value from the `source` object will be used.
            destination[key] = copy.deepcopy(source[key])


    @staticmethod
    def _handle_merge_additive(destination, source, key):
        # Values are combined into one long collection.
        if isinstance(destination[key], list) and isinstance(source[key], list):
            # Extend destination if both destination and source are `list` type.
            destination[key].extend(copy.deepcopy(source[key]))
        elif isinstance(destination[key], set) and isinstance(source[key], set):
            # Update destination if both destination and source are `set` type.
            destination[key].update(copy.deepcopy(source[key]))
        elif isinstance(destination[key], tuple) and isinstance(source[key], tuple):
            # Update destination if both destination and source are `tuple` type.
            destination[key] = destination[key] + copy.deepcopy(source[key])
        elif isinstance(destination[key], collections.Counter) and isinstance(source[key], collections.Counter):
            # Update destination if both destination and source are `Counter` type.
            destination[key].update(copy.deepcopy(source[key]))
        else:
            DeepMerge._handle_merge[Strategy.REPLACE](destination, source, key)


    @staticmethod
    def _handle_merge_typesafe(destination, source, key, strategy: Strategy):
        # Raise a TypeError if the destination and source types differ.
        if type(destination[key]) is not type(source[key]):
            raise TypeError(f'destination type: {type(destination[key])} differs from source type: {type(source[key])} for key: "{key}"')
        else:
            DeepMerge._handle_merge[strategy](destination, source, key)


    @staticmethod
    def _is_recursive_merge(a, b):
        both_mapping = isinstance(a, collections.abc.Mapping) and isinstance(b, collections.abc.Mapping)
        both_counter = isinstance(a, collections.Counter) and isinstance(b, collections.Counter)
        return both_mapping and not both_counter


    @staticmethod
    def _deepmerge(dst, src, strategy: Strategy = Strategy.REPLACE) -> typing.MutableMapping:
        #logger.info(f'dst={dst} src={src} strategy={strategy}')
        for key in src:
            if key in dst:
                if DeepMerge._is_recursive_merge(dst[key], src[key]):
                    # If the key for both `dst` and `src` are both Mapping types (e.g. dict), then recurse.
                    DeepMerge._deepmerge(dst[key], src[key], strategy)
                elif dst[key] is src[key]:
                    # If a key exists in both objects and the values are `same`, the value from the `dst` object will be used.
                    pass
                else:
                    #logger.info(f'key={strategy}')
                    #logger.info(f'key={getattr(Strategy, strategy)}')
                    strategy_key = getattr(Strategy, strategy)
                    #logger.info(f'available_keys={DeepMerge._handle_merge.keys()}')
                    #DeepMerge._handle_merge.get(strategy)(dst, src, key)
                    DeepMerge._handle_merge.get(strategy_key)(dst, src, key)
            else:
                # If the key exists only in `src`, the value from the `src` object will be used.
                #logger.info(f'{strategy} key0={key}')
                #logger.info(f'src={src}')
                dst[key] = copy.deepcopy(src[key])
        return dst


    @staticmethod
    def merge(destination: typing.MutableMapping, *sources: collections.abc.Mapping, strategy: Strategy = Strategy.REPLACE) -> typing.MutableMapping:
        """
        A deep merge function for 🐍.
        :param destination: The destination mapping.
        :param sources: The source mappings.
        :param strategy: The merge strategy.
        :return:
        """
        #logger.info(f'sources={sources}')
        merge_strat_fn = functools.partial(DeepMerge._deepmerge, strategy=strategy)
        return functools.reduce(merge_strat_fn, sources, destination)


DeepMerge._handle_merge = {
    Strategy.REPLACE: DeepMerge._handle_merge_replace,
    Strategy.ADDITIVE: DeepMerge._handle_merge_additive,
    Strategy.TYPESAFE: functools.partial(DeepMerge._handle_merge_typesafe, strategy=Strategy.REPLACE),
    Strategy.TYPESAFE_REPLACE: functools.partial(DeepMerge._handle_merge_typesafe, strategy=Strategy.REPLACE),
    Strategy.TYPESAFE_ADDITIVE: functools.partial(DeepMerge._handle_merge_typesafe, strategy=Strategy.ADDITIVE),
}



class JSONStream():
    """
    A streaming byte oriented JSON parser.  Feed it a single byte at a time and
    it will emit complete objects as it comes across them.  Whitespace within
    and between objects is ignored.  This means it can parse newline delimited
    JSON.
    This is essentially a class-ified version of the SO answer.
    See: https://stackoverflow.com/a/47638751
    """

    TRUE = [0x72, 0x75, 0x65]

    FALSE = [0x61, 0x6c, 0x73, 0x65]

    NULL = [0x75, 0x6c, 0x6c]


    @staticmethod
    def read_to(handler_fn, input_str: str) -> None:
        state = JSONStream.json_machine(handler_fn)
        for char in input_str:
            state = state(ord(char))


    @staticmethod
    def json_machine(emit, next_func=None):
        def _value(byte_data):
            if not byte_data:
                return

            if byte_data == 0x09 or byte_data == 0x0a or byte_data == 0x0d or byte_data == 0x20:
                return _value # Ignore whitespace

            if byte_data == 0x22: # "
                return JSONStream.string_machine(on_value)

            if byte_data == 0x2d or (0x30 <= byte_data < 0x40): # - or 0-9
                return JSONStream.number_machine(byte_data, on_number)

            if byte_data == 0x7b: #:
                return JSONStream.object_machine(on_value)

            if byte_data == 0x5b: # [
                return JSONStream.array_machine(on_value)

            if byte_data == 0x74: # t
                return JSONStream.constant_machine(JSONStream.TRUE, True, on_value)

            if byte_data == 0x66: # f
                return JSONStream.constant_machine(JSONStream.FALSE, False, on_value)

            if byte_data == 0x6e: # n
                return JSONStream.constant_machine(JSONStream.NULL, None, on_value)

            if next_func == _value:
                raise ValueError(f'Unexpected 0x{str(byte_data)}')

            return next_func(byte_data)


        def on_value(value):
            emit(value)
            return next_func


        def on_number(number, byte):
            emit(number)
            return _value(byte)


        next_func = next_func or _value

        return _value


    @staticmethod
    def constant_machine(bytes_data, value, emit):
        i = 0
        length = len(bytes_data)


        def _constant(byte_data):
            nonlocal i
            if byte_data != bytes_data[i]:
                i += 1
                raise Exception("Unexpected 0x" + str(byte_data))

            i += 1
            if i < length:
                return _constant
            return emit(value)


        return _constant


    @staticmethod
    def string_machine(emit):
        string = ""

        def _string(byte_data):
            nonlocal string

            if byte_data == 0x22: # "
                return emit(string)

            if byte_data == 0x5c: # \
                return _escaped_string

            if byte_data & 0x80: # UTF-8 handling
                return utf8_machine(byte_data, on_char_code)

            if byte_data < 0x20: # ASCII control character
                raise Exception("Unexpected control character: 0x" + str(byte_data))

            string += chr(byte_data)
            return _string


        def _escaped_string(byte_data):
            nonlocal string

            if byte_data == 0x22 or byte_data == 0x5c or byte_data == 0x2f: # " \ /
                string += chr(byte_data)
                return _string

            if byte_data == 0x62: # b
                string += "\b"
                return _string

            if byte_data == 0x66: # f
                string += "\f"
                return _string

            if byte_data == 0x6e: # n
                string += "\n"
                return _string

            if byte_data == 0x72: # r
                string += "\r"
                return _string

            if byte_data == 0x74: # t
                string += "\t"
                return _string

            if byte_data == 0x75: # u
                return hex_machine(on_char_code)


        def on_char_code(char_code):
            nonlocal string
            string += chr(char_code)
            return _string


        return _string


    @staticmethod
    def utf8_machine(byte_data, emit):
        """Nestable state machine for UTF-8 Decoding."""
        left = 0
        num = 0


        def _utf8(byte_data):
            nonlocal num, left
            if (byte_data & 0xc0) != 0x80:
                raise ValueError(f'Invalid byte in UTF-8 character: 0x{byte_data.toString(16)}')

            left = left - 1

            num |= (byte_data & 0x3f) << (left * 6)
            if left:
                return _utf8
            return emit(num)


        if 0xc0 <= byte_data < 0xe0: # 2-byte UTF-8 Character
            left = 1
            num = (byte_data & 0x1f) << 6
            return _utf8

        if 0xe0 <= byte_data < 0xf0: # 3-byte UTF-8 Character
            left = 2
            num = (byte_data & 0xf) << 12
            return _utf8

        if 0xf0 <= byte_data < 0xf8: # 4-byte UTF-8 Character
            left = 3
            num = (byte_data & 0x07) << 18
            return _utf8

        raise ValueError(f'Invalid byte in UTF-8 string: 0x{str(byte_data)}')


    @staticmethod
    def hex_machine(emit):
        """Nestable state machine for hex escaped characters."""
        left = 4
        num = 0


        def _hex(byte_data):
            nonlocal num, left

            if 0x30 <= byte_data < 0x40:
                i = byte_data - 0x30
            elif 0x61 <= byte_data <= 0x66:
                i = byte_data - 0x57
            elif 0x41 <= byte_data <= 0x46:
                i = byte_data - 0x37
            else:
                raise Exception("Expected hex char in string hex escape")

            left -= 1
            num |= i << (left * 4)

            if left:
                return _hex
            return emit(num)


        return _hex


    @staticmethod
    def number_machine(byte_data, emit):
        sign = 1
        number = 0
        decimal = 0
        esign = 1
        exponent = 0


        def _mid(byte_data):
            if byte_data == 0x2e: # .
                return _decimal

            return _later(byte_data)


        def _number(byte_data):
            nonlocal number
            if 0x30 <= byte_data < 0x40:
                number = number * 10 + (byte_data - 0x30)
                return _number

            return _mid(byte_data)


        def _start(byte_data):
            if byte_data == 0x30:
                return _mid

            if 0x30 < byte_data < 0x40:
                return _number(byte_data)

            raise ValueError(r'Invalid number: 0x{str(byte_data)}')


        if byte_data == 0x2d: # -
            sign = -1
            return _start


        def _decimal(byte_data):
            nonlocal decimal
            if 0x30 <= byte_data < 0x40:
                decimal = (decimal + byte_data - 0x30) / 10
                return _decimal

            return _later(byte_data)


        def _later(byte_data):
            if byte_data == 0x45 or byte_data == 0x65: # E e
                return _esign

            return _done(byte_data)


        def _esign(byte_data):
            nonlocal esign
            if byte_data == 0x2b: # +
                return _exponent

            if byte_data == 0x2d: # -
                esign = -1
                return _exponent

            return _exponent(byte_data)


        def _exponent(byte_data):
            nonlocal exponent
            if 0x30 <= byte_data < 0x40:
                exponent = exponent * 10 + (byte_data - 0x30)
                return _exponent

            return _done(byte_data)


        def _done(byte_data):
            value = sign * (number + decimal)
            if exponent:
                value *= math.pow(10, esign * exponent)

            return emit(value, byte_data)

        return _start(byte_data)


    @staticmethod
    def array_machine(emit):
        array_data = []


        def _array(byte_data):
            if byte_data == 0x5d: # ]
                return emit(array_data)

            return JSONStream.json_machine(on_value, _comma)(byte_data)


        def on_value(value):
            array_data.append(value)


        def _comma(byte_data):
            if byte_data == 0x09 or byte_data == 0x0a or byte_data == 0x0d or byte_data == 0x20:
                return _comma # Ignore whitespace

            if byte_data == 0x2c: # ,
                return JSONStream.json_machine(on_value, _comma)

            if byte_data == 0x5d: # ]
                return emit(array_data)

            raise ValueError(f'Unexpected byte: 0x{str(byte_data)} in array body')


        return _array


    @staticmethod
    def object_machine(emit):
        object_data = {}
        key = None


        def _object(byte_data):
            if byte_data == 0x7d: #
                return emit(object_data)

            return _key(byte_data)


        def _key(byte_data):
            if byte_data == 0x09 or byte_data == 0x0a or byte_data == 0x0d or byte_data == 0x20:
                return _object # Ignore whitespace

            if byte_data == 0x22:
                return JSONStream.string_machine(on_key)

            raise ValueError(f'Unexpected byte: 0x{str(byte_data)}')


        def on_key(result):
            nonlocal key
            key = result
            return _colon


        def _colon(byte_data):
            if byte_data == 0x09 or byte_data == 0x0a or byte_data == 0x0d or byte_data == 0x20:
                return _colon # Ignore whitespace

            if byte_data == 0x3a: # :
                return JSONStream.json_machine(on_value, _comma)

            raise ValueError(f'Unexpected byte: 0x{str(byte_data)}')


        def on_value(value):
            object_data[key] = value


        def _comma(byte_data):
            if byte_data == 0x09 or byte_data == 0x0a or byte_data == 0x0d or byte_data == 0x20:
                return _comma # Ignore whitespace

            if byte_data == 0x2c: # ,
                return _key

            if byte_data == 0x7d: #
                return emit(object_data)

            raise ValueError(f'Unexpected byte: 0x{str(byte_data)}')


        return _object



def parse_opts(args: [str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__,
        argument_default=False,
    )

    parser.add_argument('-q', '--quiet', default=False, action='store_true', help='Reduce log output to errors only')
    parser.add_argument('-s', '--stream', default=False, action='store_true', help='Treat inputs as streams of JSON objects')
    parser.add_argument('-v', '--verbose', default=False, action='store_true', help='Display verbose log output')

    strategy_choices = list(filter(lambda s: not s.startswith('__'), dir(Strategy)))
    parser.add_argument('strategy', choices=strategy_choices, help=f'merge strategy to use, one of: {strategy_choices}')
    parser.add_argument('args', nargs='+', default=[], help='input files, or "-" to read from STDIN (n.b. this implies --stream=True')
    
    opts = parser.parse_args(args)

    if opts.verbose:
        logger.setLevel(logging.DEBUG)
    elif opts.quiet:
        logger.setLevel(logging.ERROR)

    if opts.args[0] == '-' and not opts.stream:
        logger.debug('--stream mode automatically activated due to input-mode=STDIN')
        opts.s = opts.stream = True

    return opts


def do_merge(objects: [typing.Any], strat: Strategy) -> None:
    dst = {}
    DeepMerge.merge(dst, *objects, strategy=strat)
    print(json.dumps(dst))


def main(args: [str]) -> int:
    try:
        opts = parse_opts(args)

        if opts.args[0] == '-':
            # Read from STDIN.
            objects = []


            def collector(obj: typing.Any) -> None:
                objects.append(obj)


            JSONStream.read_to(collector, sys.stdin.read())

            do_merge(objects, opts.strategy)
        else:
            # Read each file.
            raise NotImplementedError('multi-file support not yet implemented, for now use "-" STDIN option')

    except BaseException as e:
        logger.exception('Problem encountered in main()')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))