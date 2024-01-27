#!/usr/bin/env python

"""
USAGE:
cat awholebunchoflogfiles*.csv | python pipesearch.py \
    'data.someproperty.feature~="(test|other)"' \
    'data.someproperty.another^="prefix"' \
    'data.someproperty.yetanother$="suffix"' \
    'data.someproperty.thatother*="textwithin"'
Filter expressions will be collectively combined as AND-ed together; multiple
expressions further constrain the resulting set.
Expects records like:
    2016-07-01T00:00:00,EventTypeName,"{""data"":{""someproperty"":{""feature"":""test"",""another"":""prefixthistext""}}"
When embedded in CSV, all JSON text must be double-quoted, as a mode of "escaping"
quotes from the CSV parser.
"""

import logging as _logging
import re
import sys
import csv
import json

logger = _logging.getLogger(__name__)
logger.setLevel(_logging.DEBUG)
logger.addHandler(_logging.StreamHandler())

RE_SEARCH_EXPR = re.compile(r'^([a-z][a-z0-9_\$\-\.]+)(==?|~=|\*=|!=|^=|$=)"([^"]*)"', flags=re.I)

def scanner(_buffer):
    reader = csv.DictReader(_buffer, fieldnames=('Timestamp','EventType','EventData'))
    for record in reader:
        try:
            data = json.loads(record.get('EventData'))
            yield record.get('Timestamp'), record.get('EventType'), data
        except Exception, e:
            # logger.error(e)
            continue


def resolve(expr, record, default=None):
    if expr == 'EventType':
        return record[1]
    if expr == 'Timestamp':
        return record[0]
    else:
        state = record[2]
        if state is None:
            return default
        for part in expr.split('.'):
            if isinstance(state, basestring):
                return state
            state = state.get(part, None)
            if state is None:
                return default
        return state


def make_filter(*expressions):

    def _eval(expr):
        consider = expr.group(1)
        operator = expr.group(2)
        comparator = expr.group(3)

        if operator in ('=', '=='):
            return lambda r: (resolve(consider, r) == comparator)
        if operator in ('!=',):
            return lambda r: (resolve(consider, r) != comparator)
        if operator in ('*=',):
            return lambda r: (comparator in resolve(consider, r, ''))
        if operator in ('^=',):
            return lambda r: (resolve(consider, r, '').startswith(comparator))
        if operator in ('$=',):
            return lambda r: (resolve(consider, r, '').endswith(comparator))
        if operator in ('~=',):
            return lambda r: bool(re.match(comparator, resolve(consider, r, '')))


    expressions = [RE_SEARCH_EXPR.match(expr) for expr in expressions]
    expressions = [_eval(expr) for expr in expressions if expr is not None]

    def _filter(record):
        matches = True

        for expr in expressions:
            matches = matches and expr(record)

        return matches
    return _filter



def search(_buffer, args):
    if callable(args):
        _filter = args
    if isinstance(args, (list, tuple)):
        _filter = make_filter(*args)
    for record in scanner(_buffer):
        if _filter(record):
            yield record





def main(args=None):
    for record in search(sys.stdin, args):
        print repr(record)



if __name__ == '__main__':
    main(sys.argv[1:])