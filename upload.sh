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
    if [ ! -d "${OUTDIR}" ]; then
        err "output directory cannot be found"
        exit ${EX_NOINPUT}
    fi

    local image
    image="$1"

    if [ -z "${image}" ]; then
        usage
        exit ${EX_USAGE}
    fi

    if [ ! -d "${OUTDIR}/${image}" ]; then
        err "image '${image}' cannot be found"
        exit ${EX_NOINPUT}
    fi

    shift

    if [ $# -eq 0 ]; then
        usage
        exit ${EX_USAGE}
    fi

    local url
    for url in "$@"; do
        upload "${OUTDIR}" "${image}" "${url}"
    done

    exit ${EX_OK}
}

usage()
{
    echo "usage: upload.sh <image> <url> ..."
}

main "$@"
