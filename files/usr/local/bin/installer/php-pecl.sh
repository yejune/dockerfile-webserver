#!/bin/bash
set -e

RESET='\e[0m'
IRed='\e[0;91m'
IGreen='\e[0;92m'
IBlue='\e[94m';

function trim() {
    local var=${@}
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

function print_w(){
    local msg=$(trim ${@});
    printf "${IBlue}${msg} ${RESET}\n";
}

function PrintOK() {
    MSG=${1}
    CHECK=${2:-0}

    if [ ${CHECK} == 0 ];
    then
        printf "${IGreen}[OK] ${MSG} ${RESET} \n"
    else
        printf "${IRed}[FAIL] ${MSG} ${RESET} \n"
        printf "${IRed}[FAIL] Stopped script ${RESET} \n"
        exit 0;
    fi
}


function pecl_download() {
    if [ ! -z $1 ]; then
        local lib_fullname=$1
    fi
    #local lib_fullname=${@}

    mkdir -p /usr/src/pecl

    cd /usr/src/pecl

    wget -q -c http://pecl.php.net/get/${lib_fullname}.tgz

    #	PrintOK "Download check  ${lib_fullname}.tgz" $?
    find ${lib_fullname}.tgz

    PrintOK "File check ${lib_fullname}.tgz" $?
    tar zxf ${lib_fullname}.tgz
}

function phpize_install() {
    #local lib=$1
    #local opt=$2

    if [ ! -d "/usr/src/pecl/${lib_fullname}" ]; then
        pecl_download
    fi

    pushd ${lib_fullname}

    phpize
    ./configure ${opt}   > /dev/null
    PrintOK "PHP PECL ${lib_fullname} : ./configure ${opt}" $?
    make -j"$(nproc)"    > /dev/null
    PrintOK "PHP PECL ${lib_fullname} : make " $?
    make install         > /dev/null
    PrintOK "PHP PECL ${lib_fullname} : make install " $?

    find "${extension_path}/${lib_shortname}.so" >>/dev/null
    PrintOK "PHP PECL ${lib_fullname} : ${extension_path}/${lib_shortname}.so" $?

    if [ ! -f "$extension_ini/${lib_shortname}.ini" ]
    then
        echo "extension=${lib_shortname}.so" > $extension_ini/${lib_shortname}.ini
    fi
	popd
    rm -rf ${lib_fullname}
}

extension_path=`php-config --extension-dir`
extension_ini="/etc/php/conf.d"

WORK_DIR="/usr/src/pecl";

if [ ! -d "$WORK_DIR" ]
then
    print_w "Make Directory - $WORK_DIR"
    mkdir -v $WORK_DIR
fi

cd $WORK_DIR

echo "extension-dir: $extension_path";
echo "install lib list : $PHP_LIB";

a=($PHP_LIB)
c=${#a[@]}
for ((index=0; index < c; index++)); do
    lib_fullname="${a[index]}"
    opt=""
    n="${a[index+1]}"

    if [ ! -z "$n" ]; then
        ff=${n:0:1}

        if [ "$ff" = "-" ]; then
            index=$((index+1))
            for ((j=index; j < c; j++)); do

                f=${a[j]:0:1}

                if [ "$f" = "-" ]
                then
                    opt="$opt ${a[j]}"
                    index=$j
                    continue
                else
                    break
                fi
            done
        fi
    fi

    rm -rf ${lib_fullname}.tgz
	rm -rf ${lib_fullname}
	print_w "PHP PECL Installing : ${lib_fullname}"

    IN="${lib_fullname}"
    arrIN=(${lib_fullname//-/ })
    lib_shortname="${arrIN[0]}"

    if [ -f "/usr/local/bin/installer/pecl/${lib_shortname}.sh" ]; then
        source "/usr/local/bin/installer/pecl/${lib_shortname}.sh"
    else
        phpize_install
    fi

done
