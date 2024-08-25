#!/bin/sh

BASEDIR=`dirname -- "$0"` || exit $?
BASEDIR=`realpath -- "${BASEDIR}"` || exit $?

. "${BASEDIR}/default.conf"

if [ -f "${BASEDIR}/config.conf" ]; then
    . "${BASEDIR}/config.conf"
fi

. "${BASEDIR}/lib.subr" 

main()
{
    if [ $# -lt 1 ]; then
        usage
        exit ${EX_USAGE}
    fi

    local commit_msg
    commit_msg="$1"

    if [ ! -d "${MAKEJAILSDIR}" ]; then
        err "directory '${MAKEJAILSDIR}' cannot be found"
        exit ${EX_NOINPUT}
    fi

    ls -1 -- "${MAKEJAILSDIR}" | while IFS= read -r dir; do
        makejaildir="${MAKEJAILSDIR}/${dir}"

        git -C "${makejaildir}" add .
        git -C "${makejaildir}" commit -m "${commit_msg}"
    done

    exit ${EX_OK}
}

usage()
{
    echo "usage: commit-all.sh <commit-message>"
}

main "$@"
