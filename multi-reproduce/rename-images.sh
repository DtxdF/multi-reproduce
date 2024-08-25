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
    local src
    src="$1"

    local dst
    dst="$2"

    if [ -z "${src}" -o -z "${dst}" ]; then
        usage
        exit ${EX_USAGE}
    fi

    shift 2

    if [ $# -eq 0 ]; then
        usage
        exit ${EX_USAGE}
    fi

    local url
    for url in "$@"; do
        if ! printf -- "-@ls -1 %s\n" "${src}" | sftp -b - "${url}"; then
            warn "Error getting directories in '${url}/${src}'"
        fi |\
        while IFS= read -r subdir; do
            image=`basename -- "${subdir}"` || continue

            printf -- "-@rename %s %s\n" "${subdir}" "${dst}/${image}"
        done | sftp -b - "${url}"

        if [ $? -ne 0 ]; then
            warn "Error renaming directories in '${url}'"
        fi
    done

    exit ${EX_OK}
}

usage()
{
    echo "usage: rename-images.sh <src> <dst> <url> ..."
}

main "$@"
