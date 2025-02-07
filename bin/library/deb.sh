#!/usr/bin/env bash
if [[ "${BASHOPTS}" != *extdebug* ]]; then
    set -e
fi

err_report() {
    echo "ERROR: $0:$*"
    exit 8
}

if [[ "${BASHOPTS}" != *extdebug* ]]; then
    trap 'err_report $LINENO' ERR
fi

source=$(pwd)

pwd=$(cd "$(dirname $(dirname $(dirname "${BASH_SOURCE[0]}")))" &> /dev/null && pwd)

function build-debian-package() {
    local file
    local files
    local config
    local pkgs
    local skip
    local pwd
    local pkg=$1
    local opts=${@:1}
    pwd=$(get-cwd)

    for opt in ${opts[@]}; do
        case ${opt} in

            "--no-update")
                skip="--skip"
                ;;

            *)
                ;;

        esac
    done

    if [ "${skip}" != "--skip" ]; then
        apt install -y --fix-broken
        apt update -y --fix-missing
        dpkg --configure -a

        export DEBIAN_FRONTEND=noninteractive

        # requires root
        set -a && eval "$(tee --append /etc/environment <<<'DEBIAN_FRONTEND=noninteractive')" && set +a
    fi

    mkdir -p "${pwd}/deb"

    export BUILD_DIR="$(dirname $(dirname "${pwd}/out"))"
    export DEST_DIR="$(dirname $(dirname "${pwd}/deb"))"
    
    make clean
    make package

    unlink "${pwd}/out/${pkg}"

    rm -rf "${pwd}/out"
}

export -f build-debian-package
