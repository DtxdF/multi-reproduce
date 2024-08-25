#!/bin/sh

BASEDIR=`dirname -- "$0"` || exit $?
BASEDIR=`realpath -- "${BASEDIR}"` || exit $?

. "${BASEDIR}/default.conf"

if [ -f "${BASEDIR}/config.conf" ]; then
    . "${BASEDIR}/config.conf"
fi

main()
{
    local clone_type
    clone_type="${1:-ssh}"

    case "${clone_type}" in
        ssh) clone_type="ssh_url" ;;
        clone) clone_Type="clone_url" ;;
        *) usage; exit ${EX_USAGE} ;;
    esac

    local output
    local index=0

    if [ ! -d "${MAKEJAILSDIR}" ]; then
        mkdir -p -- "${MAKEJAILSDIR}" || exit $?
    fi

    while true; do
        output=`fetch -qo - https://api.github.com/users/AppJail-makejails/repos?page=${index} 2> /dev/null | jq -r ".[].${clone_type}"`

        if [ -z "${output}" ]; then
            break
        fi

        local repo

        for repo in ${output}; do
            git -C "${MAKEJAILSDIR}" clone "${repo}"
        done

        index=$((index+1))
    done

    exit ${EX_OK}
}

usage()
{
    echo "usage: clone-all.sh [ssh|clone]"
}

main "$@"
