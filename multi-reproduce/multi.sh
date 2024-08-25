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

    local file
    file="$1"

    if [ ! -f "${file}" ]; then
        err "file '${file}' cannot be found"
        exit ${EX_NOINPUT}
    fi

    while IFS= read -r project; do
        setprefix "${project}"

        if ! "${BASEDIR}/single.sh" "${project}"; then
            err "an error has been occurred"
            err "^^^^^^^^^^^^^^^^^^^^^^^^^^"
        fi
    done < "${file}"

    exit ${EX_OK}
}

usage()
{
    echo "usage: multi.sh <file>"
}

main "$@"
