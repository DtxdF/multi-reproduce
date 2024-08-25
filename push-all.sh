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
    if [ ! -d "${MAKEJAILSDIR}" ]; then
        err "directory '${MAKEJAILSDIR}' cannot be found"
        exit ${EX_NOINPUT}
    fi

    ls -1 -- "${MAKEJAILSDIR}" | while IFS= read -r dir; do
        git -C "${MAKEJAILSDIR}/${dir}" push
    done

    exit ${EX_OK}
}

main "$@"
