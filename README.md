# tools 各种脚本工具

## 安装 `The Silver Searcher` (`ag`)

### 直接安装

#### macOS

    brew install the_silver_searcher

or

    port install the_silver_searcher


#### Linux

* Ubuntu >= 13.10 (Saucy) or Debian >= 8 (Jessie)

        apt-get install silversearcher-ag

* Fedora 21 and lower

        yum install the_silver_searcher

* Fedora 22+

        dnf install the_silver_searcher

* RHEL7+

        yum install epel-release.noarch the_silver_searcher

* Gentoo

        emerge -a sys-apps/the_silver_searcher

* Arch

        pacman -S the_silver_searcher

* Slackware

        sbopkg -i the_silver_searcher

* openSUSE:

        zypper install the_silver_searcher

* CentOS:

        yum install the_silver_searcher

* SUSE Linux Enterprise: Follow [these simple instructions](https://software.opensuse.org/download.html?project=utilities&package=the_silver_searcher).


#### BSD

* FreeBSD

        pkg install the_silver_searcher

* OpenBSD/NetBSD

        pkg_add the_silver_searcher

#### Windows

* Win32/64

  Unofficial daily builds are [available](https://github.com/k-takata/the_silver_searcher-win32).

* Chocolatey

        choco install ag
* MSYS2

        pacman -S mingw-w64-{i686,x86_64}-ag
* Cygwin

  Run the relevant [`setup-*.exe`](https://cygwin.com/install.html), and select "the\_silver\_searcher" in the "Utils" category.

### 脚本安装

* [ag_install.sh](ag_install.sh)
