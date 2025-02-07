#!/usr/bin/env bash
if [[ "${BASHOPTS}" != *extdebug* ]]; then
    set -e
fi

err_report() {
    cd ${source}
    echo "ERROR: $0:$*"
    exit 8
}

if [[ "${BASHOPTS}" != *extdebug* ]]; then
    trap 'err_report $LINENO' ERR
fi

uid=$(id -u)

source=$(pwd)

pwd=$(cd "$(dirname $(dirname "${BASH_SOURCE[0]}"))" &> /dev/null && pwd)

cd "${pwd}"

install="$1"

opts=( "${@:2}" )

. "${pwd}/bin/scripts/load.sh"

if [[ "${install}" == "--help" ]]; then
    help
    exit
fi

for i in "$@"; do
    if [[ "$i" == "--no-update" ]]; then
        updateflags="--no-update"
    fi
done

for i in "$@"; do
    if [[ "$i" == "--skip" ]]; then
        skip="--skip"
    fi
done

for i in "$@"; do
    if [[ "$i" == "--help" ]]; then
        help="--help"
    fi
done

if [[ "${help}" == "--help" ]]; then
    help
    exit 8
fi

if [ "${skip}" != "--skip" ]; then
    if [[ ! "${uid}" -eq 0 ]]; then
        echo "Please run as root"
        exit
    fi
fi


## Builds deban packages from source
## Usage: ${script} <option> [optional]
## ${commands}

while (($#)); do
    case "$1" in

        "--setup") # installs dependencies for package build
            DEBIAN_FRONTEND=noninteractive apt install -y build-essential debhelper dh-make fakeroot
            ;;

        "--helloworld") # builds debian package for helloworld
            build-debian-package helloworld ${updateflags}
            ;;

        "--skip") # [optional] skip sudo checks
            ;;

        "--no-update") # [optional] skip system update
            ;;

        "--help") # [optional] shows command description
            help
            ;;

        *)
            help
            ;;

    esac
    shift
done

if [[ "${install}" == "" ]]; then
    help
    exit;
fi

[[ $SHLVL -gt 2 ]] || echo OK

cd "${pwd}"
