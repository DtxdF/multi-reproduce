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

    local project
    project="$1"

    setprefix "${project}"

    info "building"

    if [ ! -d "${LOGSDIR}" ]; then
        mkdir -p -- "${LOGSDIR}" || exit $?
    fi

    local errors
    errors=`appjail-reproduce -fb "${project}" 2>&1 | tee -- "logs/${project}.log" | grep error | wc -l | tr -d ' '`

    if [ ${errors} -gt 0 ]; then
        err "number of errors is ${errors}"
        exit ${EX_SOFTWARE}
    fi

    if [ ! -d "${OUTDIR}" ]; then
        mkdir -p -- "${OUTDIR}" || exit $?
    fi

    local imagedir
    imagedir="${IMAGESDIR}/${project}"

    local outdir
    outdir="${OUTDIR}/${project}"

    if [ -d "${outdir}" ]; then
        info "removing ${outdir}"

        rm -rf -- "${outdir}" || exit $?
    fi

    info "copying ${imagedir} -> ${outdir}"

    cp -a -- "${imagedir}" "${outdir}" || exit $?

    info "destroying ${project}"

    appjail image remove -- "${project}" || exit 4?

    exit ${EX_OK}
}

usage()
{
    echo "usage: single.sh <project>"
}

main "$@"
