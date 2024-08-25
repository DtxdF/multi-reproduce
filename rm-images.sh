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
    local dir
    dir="$1"

    if [ -z "${dir}" ]; then
        usage
        exit ${EX_USAGE}
    fi

    shift

    if [ $# -eq 0 ]; then
        usage
        exit ${EX_USAGE}
    fi

    local url
    for url in "$@"; do
        if ! printf -- "-@rm %s/*/*.appjail\n" "${dir}" | sftp -b - "${url}"; then
            warn "Error removing images in '${url}/${dir}'"
        fi

        if ! printf -- "-@ls -1 %s\n" "${dir}" | sftp -b - "${url}"; then
            warn "Error getting directories in '${url}/${dir}'"
        fi |\
        while IFS= read -r subdir; do
            printf -- "-@rmdir %s\n" "${subdir}"
        done | sftp -b - "${url}"

        if [ $? -ne 0 ]; then
            warn "Error removing directories in '${url}/${dir}'"
        fi
    done

    exit ${EX_OK}
}

usage()
{
    echo "usage: rm-images.sh <dir> <url> ..."
}

main "$@"
