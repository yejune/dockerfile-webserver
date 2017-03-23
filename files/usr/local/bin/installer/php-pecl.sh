#!/bin/bash
set -e

RESET='\e[0m'
IRed='\e[0;91m'
IGreen='\e[0;92m'
IBlue='\e[94m';

function pecl() {
    local lib=${@}

    mkdir -p /usr/src/pecl

    cd /usr/src/pecl

    wget -q -c http://pecl.php.net/get/${lib}.tgz

    #	PrintOK "Download check  ${lib}.tgz" $?
    find ${lib}.tgz

    PrintOK "File check ${lib}.tgz" $?
    tar zxf ${lib}.tgz
}

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
    lib="${a[index]}"
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

    rm -rf ${lib}.tgz
	rm -rf ${lib}
	print_w "PHP PECL Installing : ${lib}"

    IN="$lib"
    arrIN=(${lib//-/ })
    libname="${arrIN[0]}"

    if [ -f "/usr/local/bin/installer/pecl/${libname}.sh" ]; then
        source "/usr/local/bin/installer/pecl/${libname}.sh"
    else
        pecl ${lib}
    fi

    pushd ${lib}

    phpize
    ./configure ${opt}   > /dev/null
    PrintOK "PHP PECL ${lib} : ./configure ${opt}" $?
    make -j"$(nproc)"    > /dev/null
    PrintOK "PHP PECL ${lib} : make " $?
    make install         > /dev/null
    PrintOK "PHP PECL ${lib} : make install " $?

    checkfile=`echo ${lib}| cut -d "-" -f1`
    find "${extension_path}/${checkfile}.so" >>/dev/null
    PrintOK "PHP PECL ${lib} : ${extension_path}/${checkfile}.so" $?

    if [ ! -f "$extension_ini/${checkfile}.ini" ]
    then
        echo "extension=${checkfile}.so" > $extension_ini/${checkfile}.ini
    fi
	popd
    rm -rf ${lib}

done