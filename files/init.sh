#!/bin/bash
set -ex

if [[ `(which sudo 2> /dev/null)` = "" ]];then
    sudo=""
else
    sudo="sudo"
fi

in_array()
{
    local haystack
    haystack="${1}[@]"
    local needle
    needle="${2}"
    local i=""

    for i in "${!haystack}"; do
        if [[ "${i}" == "${needle}" ]]; then
            return 0
        fi
    done
    return 1
}
pecl-download()
{
    local lib_fullname=$1

    mkdir -p ${PECL_SRC_DIR}

    cd ${PECL_SRC_DIR}

    wget -q -c http://pecl.php.net/get/${lib_fullname}.tgz

    find ${lib_fullname}.tgz

    tar zxf ${lib_fullname}.tgz

    $sudo rm -rf ${lib_fullname}.tgz
}
phpize-install()
{
    local all=($@)
    local configure_option=""
    local lib_fullname=$1

    local arrIN=(${lib_fullname//-/ })
    local lib_shortname="${arrIN[0]}"

    if [ ! -d "${PECL_SRC_DIR}/${lib_fullname}" ]; then
        pecl-download $lib_fullname
    fi

    if [ ! -z "${all[1]}" ]; then
        for ((j=1; j<"${#all[@]}"; j++)); do
            configure_option="$configure_option ${all[j]}"
        done
    fi

    cd ${PECL_SRC_DIR}/${lib_fullname}

    phpize
    ./configure \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
        --build="${BUILD_ARCH}" \
        ${configure_option}

    make -j "$(nproc)"
    $sudo make install
    #make test
    make clean

    find "${PHP_EXTENSION_DIR}/${lib_shortname}.so"

    if [ ! -f "${PHP_CONF_DIR}/${lib_shortname}.ini" ]; then
        echo "extension=${lib_shortname}.so" > "${PHP_CONF_DIR}/${lib_shortname}.ini"
    fi

	cd ..
    $sudo rm -rf ${lib_fullname}
}
ext-pcl()
{
    local all=($@)
    local fullname="${all[0]}"
    local configure_option=""
    local parts=(${fullname//-/ })
    local name="${parts[0]}"

    if [ ! -z "${all[1]}" ]; then
        for ((j=1; j<"${#all[@]}"; j++)); do
            configure_option="$configure_option ${all[j]}"
        done
    fi

    if [ -f "/usr/local/bin/installer/pecl/${name}.sh" ]; then
        source "/usr/local/bin/installer/pecl/${name}.sh"
    else
        phpize-install $fullname $configure_option
    fi
}
ext-src()
{
    local all=($@)
    local name="${all[0]}"
    local configure_option=""

    if [ ! -z "${all[1]}" ]; then
        for ((j=1; j<"${#all[@]}"; j++)); do
            configure_option="$configure_option ${all[j]}"
        done
    fi

    local extensions=("filter", "readline" "libxml" "xml" "spl" "reflection" "standard" "pcre" "date" "ftp" "mysqlnd" "fpm" "mbstring" "curl" "openssl" "zlib", "phar");
    local periods=("libxml" "session" "pdo", "igbinary", "msgpack");

    if in_array extensions "${name}"; then
        echo ""
    else
        local ext_dir="${PHP_SRC_DIR}/ext/${name}"
        cd "${ext_dir}"

        if [[ -f "${ext_dir}/config.m4" || -f "${ext_dir}/config0.m4" ]]; then
            if [[ ! -f "${ext_dir}/config.m4" && -f "${ext_dir}/config0.m4" ]]; then
                mv "${ext_dir}/config0.m4" "${ext_dir}/config.m4"
            fi
        fi

        phpize
        ./configure \
            CFLAGS="$PHP_CFLAGS" \
            CPPFLAGS="$PHP_CPPFLAGS" \
            LDFLAGS="$PHP_LDFLAGS" \
            --build="${BUILD}" \
            ${configure_option}

        make -j "$(nproc)"
        #make test
        $sudo make install
        make clean

        local ini_filename="${name}"

        if in_array periods "${name}"; then
            ini_filename="1_${name}"
        fi
        if [ ! -f "${PHP_CONF_DIR}/${ini_filename}.ini" ]; then
            if [ "${name}" = "opcache" ]; then
                echo "zend_extension=${name}.so" > "${PHP_CONF_DIR}/${ini_filename}.ini"
            else
                echo "extension=${name}.so" > "${PHP_CONF_DIR}/${ini_filename}.ini"
            fi
        fi
    fi
}
ext-lib()
{
    $sudo apt-get install -y $@
}

