# Prerequisites

Make sure to follow this guidance for your platform before any troubleshooting.

* Ubuntu/Debian:

```sh
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
```
Alternative of libreadline-dev:
```sh
sudo apt install libedit-dev
```

* CentOS/RHEL(aws ec2):

```sh
sudo yum install @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
```

* Fedora
```sh
sudo dnf group install "Development Tools"
sudo dnf install zlib-devel bzip2 bzip2-devel readline-devel sqlite \
sqlite-devel openssl-devel xz xz-devel libffi-devel findutils tk tk-devel
```

Alternative of openssl-devel:
```sh
sudo yum install compat-openssl10-devel --allowerasing
```

* openSUSE

```sh
zypper in zlib-devel bzip2 libbz2-devel libffi-devel libopenssl-devel \
readline-devel sqlite3 sqlite3-devel xz xz-devel
```

For building Python versions from source with OpenSUSE you need the packages in pattern `devel_basis`

```sh
zypper in -t pattern devel_basis
```

* Alpine

```sh
apk add --no-cache bzip2-dev coreutils dpkg-dev dpkg expat-dev \
findutils gcc gdbm-dev libc-dev libffi-dev libnsl-dev libtirpc-dev \
linux-headers make ncurses-dev openssl-dev pax-utils readline-dev \
sqlite-dev tcl-dev tk tk-dev util-linux-dev xz-dev zlib-dev
```

For installing Pyenv with [Pyenv-Installer](https://github.com/pyenv/pyenv-installer), you would need git, curl and bash
```sh
apk add git curl bash
```

* Arch and derivatives

```sh
pacman -S --needed base-devel openssl zlib bzip2 readline sqlite curl \
llvm ncurses xz tk libffi python-pyopenssl git
```
The library ncurses5 would require an [AUR Helper](https://wiki.archlinux.org/index.php/AUR_helpers) to install. If using [YAY](https://aur.archlinux.org/packages/yay/):

```sh
yay -S ncurses5-compat-libs
```

* macOS:

```sh
brew install readline xz
```

**NOTE**: `libssl-dev` is required when compiling Python, installing `libssl-dev` will actually install `zlib1g-dev`, which leads to uninstall and re-install Python versions (installed before installing `libssl-dev`). On Redhat and derivatives the package is named `openssl-devel`.

## Removing a python version

```sh
rm -rf ~/.pyenv/versions/X.Y.Z
```
Replace X.Y.Z with the version that you want to remove. To list installed versions:

```sh
pyenv versions
```

## Installing a 32 bit python on 64 bit Mac OS X (this will *not* work on Linux)

```sh
CONFIGURE_OPTS="--with-arch=i386" CFLAGS="-arch i386" LDFLAGS="-arch i386" python-build options
```

## Installing a system-wide Python
If you want to install a Python interpreter that's available to all users and system scripts (no pyenv), use `/usr/local/` as the install path. For example:

```sh
sudo python-build 3.3.2 /usr/local/
```

## Build failed - bad interpreter: Permission denied

If you encounter this error while installing python and your server is a VPS, the **/tmp** directory where python-build download and compile the packages is probably mounted as **noexec**. You can check with your hosting provider if whether they provide a way to bypass this protection.

If the answer is no, just set the **$TMPDIR** environment variable to wherever you have a write + execution rights. For example:

```sh
export TMPDIR="$HOME/src"
```

Please note you'll have to do it every time you'll want to install a new version of python unless you write this command in your `~/.bashrc`.

## Build failed

If you've got something like that:

```sh
$ pyenv install 2.7.5
Downloading http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz...
Installing yaml-0.1.4...

BUILD FAILED
```

Please, be sure to have "make" installed (```$ sudo apt-get install make```). On Ubuntu Server, by default, it doesn't.

## Build failed: "ERROR: The Python zlib extension was not compiled. Missing the zlib?"

```sh
Installing Python-2.7.7...

ERROR: The Python zlib extension was not compiled. Missing the zlib?

Please consult to the Wiki page to fix the problem.
https://github.com/pyenv/pyenv/wiki/Common-build-problems

BUILD FAILED
```

* On Mac OS X 10.9, 10.10, 10.11 and 10.13 you may need to set the CFLAGS environment variable when installing a new version in order for configure to find the zlib headers (XCode command line tools must be installed first):

```sh
CPPFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install -v 2.7.7
```

* If you installed zlib with Homebrew, you can set the CPPFLAGS environment variable:
```sh
CPPFLAGS="-I$(brew --prefix zlib)/include" pyenv install -v 3.7.0
```

* Alternatively, try reinstalling XCode command line tools for your OS

If you experience both issues with openssl and zlib, you can specify both search paths as a compiler flag:

```sh
CPPFLAGS="-I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib"
```

If you experience issues with readline, you can also specify this as a compiler flag:

```sh
CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib"
```

If you are using macOS 10.14.6 with XCode 10.3, add the following:

```sh
SDKROOT=${XCODE_ROOT}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk \
MACOSX_DEPLOYMENT_TARGET=10.14
```

## ERROR: The Python ssl extension was not compiled. Missing the OpenSSL lib?

### 0. First, check
* if you actually have OpenSSL and its headers installed (and for the right architecture and ecosystem if there are more than one at your machine)
* if the problem is resolved by upgrading Pyenv to the latest release and to the head version

### 1. **OpenSSL is installed to an uncommon location.**

Pass the location of its headers and libraries explicitly:

```sh
CPPFLAGS="-I<openssl install prefix>/include" \
LDFLAGS="-L<openssl install prefix>/lib" \
pyenv install -v <python version>
```

or, alternatively, [for Python 3.7+](https://bugs.python.org/issue32598), instead of `CPPFLAGS` and `LDFLAGS`:

```sh
CONFIGURE_OPTS="--with-openssl=<openssl install prefix>"
```

E.g. (invocations that worked for various people):

* RHEL6:

    ```sh
    CPPFLAGS=-I/usr/include/openssl \
    LDFLAGS=-L/usr/lib64 \
    pyenv install -v 3.4.3
    ```

* Arch Linux:

    ```sh
    LDFLAGS="-L/usr/lib/openssl-1.0" \
    CPPFLAGS="-I/usr/include/openssl-1.0" \
    pyenv install -v 3.4.3
    ```

* If you installed openssl with macports:

    ```sh
    CPPFLAGS="-I/opt/local/include/" \
    LDFLAGS="-L/opt/local/lib/" \
    pyenv install -v 3.4.3
    ```

* On Ubuntu 14.04 on Dreamhost, an extra flag is required for Python 3.7+:
    * First, follow these instructions: https://help.dreamhost.com/hc/en-us/articles/360001435926-Installing-OpenSSL-locally-under-your-username
    * Then, run:
      ```sh
      CPPFLAGS=-I$HOME/openssl/include \
      LDFLAGS=-L$HOME/openssl/lib \
      SSH=$HOME/openssl
      pyenv install -v 3.7.2
      ```

### 2. **Your OpenSSL version is incompatible with the Python version you're trying to install**

Old Python versions (for CPython, <3.5.3 and <2.7.13) require OpenSSL 1.0 while newer systems provide 1.1, and vice versa.
Note that OpenSSL 1.0 is EOL and by now practically unusable on the Internet due to using obsolete standards.

Install the right OpenSSL version and point the build to its location as per above if needed.

E.g.:

* On Debian stretch and Ubuntu bionic, `libssl-dev` is OpenSSL 1.1.x, but support for that was only added in Python 2.7.13, 3.5.3 and 3.6.0.  To install earlier versions, you need to replace `libssl-dev` with `libssl1.0-dev`.

  ```sh
  sudo apt-get remove libssl-dev
  sudo apt-get update
  sudo apt-get install libssl1.0-dev
  ```

  https://github.com/pyenv/pyenv/issues/945#issuecomment-409627448 has a more complex workaround that preserves `libssl-dev`.

* On FreeBSD 10-RELEASE and 11-CURRENT, you may need to recompile ``security/openssl`` without SSLv2 support. (See [#464](https://github.com/yyuu/pyenv/issues/464#issuecomment-152821922)).

* On Debian Jessie, you can use backports to install OpenSSL 1.0.2: `sudo apt -t jessie-backports install openssl`


## python-build: definition not found

To update your python-build definitions:

If you have python-build installed as an pyenv plugin:

```sh
$ cd ~/.pyenv/plugins/python-build && git pull
```

## macOS: "ld: symbol(s) not found for architecture x86_64" (#1245)

From ([#1245](https://github.com/pyenv/pyenv/issues/1245)).

This may be caused by an incompatible version of `ar` bundled with brew-distributed binutils.

To fix, either `brew remove binutils` or execute the install command with `AR=/usr/bin/ar`.

## Python cannot find a dependent dynamic library even though it's installed

If you're getting messages lke this -- but you do have the corresponding package installed:

```
libreadline.so.7: cannot open shared object file: No such file or directory
```

**Check if the dynamic library's version you have installed is the same as what Python expects:**

$ ls /lib/libreadline.so*
/lib/libreadline.so  /lib/libreadline.so.8  /lib/libreadline.so.8.0

Beside build time, this can also happen for an already installed version if:

* You've installed a prebuilt version that was built for a different environment

    Many installation scripts for prebuilt versions give you a warning in such a case.

    * Get or compile the right version of the library if possible
        * it needs to be compiled for your system to avoid binary incompatibilies, so the best bets are either building from source or getting a binary from an official source for your distro; or
    * Replace the prebuilt version with a source one (usually, these are suffixed with `-src` if both a prebuilt and a source versions are provided)

* You've updated a dependent library on your system to a different major version since the time you had compiled Python

    * The easiest way would be to rebuild all affected Python installations against the new version of the library with `pyenv install <version> --force`
    * (You can also get or compile the right version of the library instead as per above)