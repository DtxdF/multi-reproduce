# multi-reproduce

**multi-reproduce** is a set of scripts to create images in bulk using [Reproduce](https://github.com/DtxdF/reproduce). The goals are to create all the images, upload them to a staging directory, write the `appjail-ajspec(5)` files, commit, and push those changes to the [Centralized Repository](https://github.com/AppJail-makejails). All of those goals should have minimal human intervention.

## Dependencies

* `jq`
* `git`
* `appjail-reproduce`
* `appjail` or `appjail-devel`

## Reproduce Configuration

**~/.config/appjail-reproduce/config.conf**:

```sh
MIRRORS="http://appjail.hpc.at https://images.all101bsd.download"
COMPRESS_ALGO=zstd
BEFORE_MAKEJAILS="/root/Mk/main.makejail"
```

**~/Mk/main.makejail**:

```
INCLUDE pkg.makejail
```

**~/Mk/pkg.makejail**:

```
CMD mkdir -p /usr/local/etc/pkg/repos
COPY /usr/local/etc/pkg/repos/Latest.conf /usr/local/etc/pkg/repos
```

## Quickstart

**Install multi-reproduce**:

```sh
git clone http://gitea.services.lan/dtxdf/multi-reproduce.git
```

**Switch to the working directory**:

```sh
cd ./multi-reproduce/wrkdir/
```

**Clone all repositories**:

```sh
../clone-all.sh
```

**Copy file lists**:

```sh
cp -a examples/ajspec.main.lst ajspec/main.lst
cp -a examples/projects.group1.lst projects/group1.lst
cp -a examples/projects.group2.lst projects/group2.lst
```

**Concatenate project files**:

If you want, you can build the first group, then upload it and follow the same process for the second group, but the most efficient way is to concatenate all the groups into one and build them in one session.

```sh
cat projects/group*.lst > projects/group.lst
```

**Build**:

```sh
../session.sh ../multi.sh projects/group.lst
```

**Upload**:

```sh
../session.sh ../upload-all.sh sftp://appjail@appjail.hpc.at:50022/appjail/stage
```

**Write `appjail-ajspec(5)`s**:

```sh
../write-ajspec.sh ajspec/main.lst
```

**Commit**:

```sh
../commit-all.sh "Weekly update"
```

**Remove public images**:

```sh
../rm-images.sh public sftp://appjail@appjail.hpc.at:50022/appjail
```

**Move stage images to the public directory**:

```sh
../rename-images.sh stage public sftp://appjail@appjail.hpc.at:50022/appjail
```

**Push**:

```sh
../push-all.sh
```

## File Format

**Line Syntax** (**Projects**): `<project-name>`

**Line Syntax** (**AJSPEC**): `<image-name>[[:<project-N>] ...]`

## To Bump

Some Makejails require changing the source project version to the new version, so it is necessary to keep track of them.

| Makejail | Last Versions |
| --- | --- |
| [Alpine Linux](https://github.com/AppJail-makejails/alpine-linux) | `3.20.2` |
| [Burp Suite](https://github.com/AppJail-makejails/burpsuite) | `2024.6.6` |
| [InvenTree](https://github.com/AppJail-makejails/inventree) | `0.15.8` |
| [AdminerEvo](https://github.com/AppJail-makejails/adminerevo) | `4.8.4` |
| [MariaDB](https://github.com/AppJail-makejails/mariadb) | `105`, `106`, `1011`, `114` |
| [WordPress](https://github.com/AppJail-makejails/wordpress) | `6.6.1` |
| [PHP](https://github.com/AppJail-makejails/php) | `81`, `82`, `83`, `84` |
| [File Browser](https://github.com/AppJail-makejails/filebrowser) | `2.30.0` |
| [GO](https://github.com/AppJail-makejails/go) | `120`, `121`, `122` |
| [Python](https://github.com/AppJail-makejails/python) | `2`, `3`, `27`, `38`. `39`. `310`. `311` |
| [Homepage](https://github.com/AppJail-makejails/homepage) | `0.9.6` |
| [Calibre Web](https://github.com/AppJail-makejails/calibreweb) | `0.6.23` |
| [Lychee](https://github.com/AppJail-makejails/lychee) | `5.5.1` |
