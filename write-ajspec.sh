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

    local tempfile
    tempfile=`mktemp` || exit $?

    local images
    while IFS= read -r images; do
        local multiple=false
        local error=false

        local name=

        local image
        for image in `printf "%s" "${images}" | tr ':' '\n'`; do
            if [ -z "${name}" ]; then
                name="${image}"
                continue
            fi

            multiple=true

            local ajspec_file
            ajspec_file="${OUTDIR}/${image}/.ajspec"

            if [ ! -f "${ajspec_file}" ]; then
                error=true
                warn "ajspec file '${ajspec_file}' cannot be found"
                break
            fi

            if ! cat -- "${ajspec_file}"; then
                error=true
                break
            fi
        done > "${tempfile}"

        if [ -z "${name}" ] || ${error}; then
            continue
        fi

        if ! ${multiple}; then
            local ajspec_file
            ajspec_file="${OUTDIR}/${name}/.ajspec"

            if [ ! -f "${ajspec_file}" ]; then
                warn "ajspec file '${ajspec_file}' cannot be found"
                continue
            fi

            if ! cat -- "${ajspec_file}" > "${tempfile}"; then
                continue
            fi
        fi

        local outdir
        outdir="${MAKEJAILSDIR}/${name}"

        if [ ! -d "${outdir}" ]; then
            warn "makejail directory '${outdir}' cannot be found"
            continue
        fi

        local outfile
        outfile="${outdir}/.ajspec"

        cat -- "${tempfile}" | sed -Ee 's/tags:/tags+:/' | sed -Ee "s/\.name: .+/.name: \"${name}\"/" > "${outfile}"
    done < "${file}"

    rm -f -- "${tempfile}"

    exit ${EX_OK}
}

usage()
{
    echo "usage: write-ajspec.sh <file>"
}

main "$@"
