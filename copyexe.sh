#!/bin/bash
# Usage : $0 <chroot_path> <program list>
rep="$1"
shift

# Copy $1 to $2 with folder creation
copy_dir ()
{
        [ -e "${2}" ] && return
        rep_base=$(dirname "${2}")
        [ -d "${rep_base}" ] || {
                echo "++ mkdir -p ${rep_base}"
                mkdir -p "${rep_base}"
        }
        echo "+ cp -a $1 $2"
        cp -a "$1" "$2"
}

# copy $1 to $2 with dependants libraries.
copy_ldd ()
{
        local src dest file f f_link
        src="$1"
        dest="$2"
        [ -e "${dest}" ] && return
        file=( $(ldd "$src" | awk '{print $3}' | grep '^/') )
        file=( "${file[@]}" $(ldd "$src" | grep '/' | grep -v '=>' | awk '{print $1}') )
        for f in "${file[@]}"
        do
                f_link=$(readlink -f "$f")
                copy_dir "$f_link" "${rep}${f}"
        done
        copy_dir "$src" "${dest}"
}

for prog in "$@"
do
        prog=$(which "$prog")
        prog_real=$(readlink -f "$prog")
        copy_ldd "$prog_real" "${rep}${prog}"
done

