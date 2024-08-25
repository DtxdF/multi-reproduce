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
    if [ $# -eq 0 ]; then
        usage
        exit ${EX_USAGE}
    fi

    if [ ! -d "${SESSIONSDIR}" ]; then
        mkdir -p -- "${SESSIONSDIR}" || exit $?
    fi

    local logfile
    logfile="${SESSIONSDIR}/`date +"%Y-%m-%d_%Hh%Mm%Ss"`.log"

    info "session log is '${logfile}'"

    "$@" 2>&1 | tee "${logfile}"

    exit ${EX_OK}
}

usage()
{
    echo "usage: session.sh <cmd> [<args> ...]"
}

main "$@"
