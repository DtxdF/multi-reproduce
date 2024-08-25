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

    if [ ! -d "${OUTDIR}" ]; then
        err "output directory cannot be found"
        exit ${EX_NOINPUT}
    fi

    ls -1 -- "${OUTDIR}" | while IFS= read -r image; do
        for url in "$@"; do
            upload "${OUTDIR}" "${image}" "${url}"
        done
    done

    exit ${EX_OK}
}

usage()
{
    echo "usage: upload-all.sh <url> ..."
}

main "$@"
