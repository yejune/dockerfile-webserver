#!/bin/bash

# is on
is_on() {
    local var=${1,,}
    case $var in
        yes|y|true|t|on|1|enabled) return 0 ;;
    esac
    return 1
}

# is on
is_off() {
    local var=${1,,}
    case $var in
        no|n|false|f|off|0|disabled|"") return 0 ;;
    esac
    return 1
}

# not off
not_off() {
    local var=${1,,}
    if is_off "$var"; then
        return 1
    else
        return 0
    fi
}

export USE_SSL=${USE_SSL:-"off"}
export SSL_DOMAINS=${SSL_DOMAINS:-"_"}
export WEBROOT_DIR=${WEBROOT_DIR:-"/var/www/public"}
export NGINX_LOCATION=${NGINX_LOCATION:-""}
export NGINX_HTTP=${NGINX_HTTP:-""}
export NGINX_SERVER=${NGINX_SERVER:-""}
export NGINX_HEADER=${NGINX_HEADER:-""}

export PHP_LOG_BUFFERING_STRING=${PHP_LOG_BUFFERING_STRING:-""}
export PHP_LOG_LIMIT_STRING=${PHP_LOG_LIMIT_STRING:-""}

export PHP_INI_DIR=${PHP_INI_DIR:-"/etc/php"}
export PHP_EXTRACONF=${PHP_EXTRACONF:-""}

# export FPM_LISTEN=${FPM_LISTEN:-"0.0.0.0:9000"}
# export FASTCGI_PASS=${FASTCGI_PASS:-"0.0.0.0:9000"}
# export FPM_USER=${FPM_USER:-"www-data"}
# export FPM_GROUP=${FPM_GROUP:-"www-data"}
export FPM_LISTEN=${FPM_LISTEN:-"/dev/shm/php-fpm.sock"}
export FASTCGI_PASS=${FASTCGI_PASS:-"unix:/dev/shm/php-fpm.sock"}

export KEEPALIVE=${KEEPALIVE:-"8"}
export KEEPALIVE_REQUESTS=${KEEPALIVE_REQUESTS:-"1000"}
export KEEPALIVE_TIMEOUT=${KEEPALIVE_TIMEOUT:-"10"}

if is_on "$KEEPALIVE_OFF"; then
    export KEEPALIVE_OFF_STRING="#"
else
    export KEEPALIVE_OFF_STRING=""
fi

export PHP_LOG_LIMIT=${PHP_LOG_LIMIT:-""}
export PHP_LOG_BUFFERING=${PHP_LOG_BUFFERING:-""}
export COREDUMP=${COREDUMP:-""}

export PHP_EXTENSIONS=${PHP_EXTENSIONS:-"php do"}
export PHP_EXTENSION_STRING=".${PHP_EXTENSIONS// / .}"
export PHP_EXTENSION_URL_REGEX="${PHP_EXTENSIONS// /|}"
export PHP_EXTENSION_PATH_INFO_REGEX=".+\.${PHP_EXTENSIONS// /|.+\\.}"
export PHP_EXTENSION_INDEX_STRING="index.${PHP_EXTENSIONS// / index.}"
export INDEX_FILENAME=${INDEX_FILENAME:-"index.php"}

export RESPONSE_SERVER_NAME=${RESPONSE_SERVER_NAME:-"BLUETOOLS"}
export PHP_SESSION_NAME=${PHP_SESSION_NAME:-"PHPSESSID"}
export PHP_SESSION_SAVE_HANDLER=${PHP_SESSION_SAVE_HANDLER:-""}
export PHP_SESSION_SAVE_PATH=${PHP_SESSION_SAVE_PATH:-""}
export PHP_SESSION_GC_MAXLIFETIME=${PHP_SESSION_GC_MAXLIFETIME:-""}
export PHP_SESSION_GC_PROBABILITY=${PHP_SESSION_GC_PROBABILITY:-""}
export PHP_SESSION_GC_DIVISOR=${PHP_SESSION_GC_DIVISOR:-""}
export PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS:-""}

export OPENSSL_CONF=${OPENSSL_CONF:-""}

export STAGE_NAME=${STAGE_NAME:-"production"}
export NGINX_ACCESS_LOG_LEVEL=""
export NGINX_ERROR_LOG_LEVEL=${NGINX_ERROR_LOG_LEVEL:-"error"}
export NGINX_ERROR_LOG_LEVEL=" ${NGINX_ERROR_LOG_LEVEL}"

export NGINX_CORS_ORIGIN=${NGINX_CORS_ORIGIN:-"*"}
export NGINX_CORS_HEADERS=${NGINX_CORS_HEADERS:-"Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization"}
export NGINX_CORS_METHODS=${NGINX_CORS_METHODS:-"GET,POST,PUT,DELETE,PATCH,OPTIONS,HEAD"}
export NGINX_CORS_EXPOSE_HEADERS=${NGINX_CORS_EXPOSE_HEADERS:-"X-Request-ID"}

export LOCALE_GEN=${LOCALE_GEN:-"ko_KR.UTF-8"}

#export ERROR_PAGE=${ERROR_PAGE:-"error_page  403 404 405 406 411 497 500 501 502 503 504 505 /error.html;"}
export ERROR_PAGE=${ERROR_PAGE:-""}

# When responding to a credentialed request, the server must specify an origin in the value of the Access-Control-Allow-Origin header, instead of specifying the "*" wildcard.
if [ "$NGINX_CORS_ORIGIN" = "*" ]; then
    export NGINX_CORS_CREDENTIALS="false";
else
    export NGINX_CORS_CREDENTIALS=${NGINX_CORS_CREDENTIALS:-"true"}
fi

export LOG_FORMAT=${LOG_FORMAT:-"main"}
export SLOW_LOG_STREAM=${SLOW_LOG_STREAM:-"/var/log/php/fpm.slow.log"};

export TZ=${TZ:-"Asia/Seoul"}
export PHP_VARIABLES_ORDER=${PHP_VARIABLES_ORDER:-"GPCS"}

export PM_TYPE=${PM_TYPE:-"ondemand"}
export PM_MAX_REQUESTS=${PM_MAX_REQUESTS:-"1000"}
export PM_MAX_CHILDREN=${PM_MAX_CHILDREN:-"100"}
export PM_PROCESS_IDLE_TIMEOUT=${PM_PROCESS_IDLE_TIMEOUT:-"60"}

if [ ! -z $PM ]; then
    export PM=${PM}
else
    PM=""
    PM="$PM
pm = ${PM_TYPE}";

    PM="$PM
pm.max_children = ${PM_MAX_CHILDREN}";

    PM="$PM
pm.max_requests = ${PM_MAX_REQUESTS}";

    PM="$PM
pm.process_idle_timeout = ${PM_PROCESS_IDLE_TIMEOUT}";

    if [ ! -z $PM_START_SERVERS ]; then
        PM="$PM
pm.start_servers = ${PM_START_SERVERS}";
    fi
    if [ ! -z $PM_MIN_SPARE_SERVERS ]; then
        PM="$PM
pm.min_spare_servers = ${PM_MIN_SPARE_SERVERS}";
    fi
    if [ ! -z $PM_MAX_SPARE_SERVERS ]; then
        PM="$PM
pm.max_spare_servers = ${PM_MAX_SPARE_SERVERS}";
    fi
    export PM=${PM}
fi

if [ ! -f "/etc/tmpl/php/www.tmpl" ]; then
    echo 'restart';
else

    # 개행, 콤마, 공백을 구분자로 사용하여 로케일 분리
    echo -e "$LOCALE_GEN" | while read -r locale; do
        if [ -n "$locale" ]; then
            echo "Generating locale: $locale"
            locale-gen "$locale"
        fi
    done

    if [ ! -z "$PHP_LOG_LIMIT" ]; then
        export PHP_LOG_LIMIT_STRING="LOG_LIMIT=${PHP_LOG_LIMIT}"
    fi

    if [ ! -z "$PHP_LOG_BUFFERING" ]; then
        export PHP_LOG_BUFFERING_STRING="LOG_BUFFERING=${PHP_LOG_BUFFERING}"
    fi

    dockerize -template /etc/tmpl/php/www.tmpl > ${PHP_INI_DIR}/php-fpm.d/www.conf

    dockerize -template /etc/tmpl/php/php-fpm.tmpl > ${PHP_INI_DIR}/php-fpm.conf


    if [ ! -z "$PHP_LOG_LIMIT" ]; then
        echo php_admin_value[log_errors_max_len] = ${PHP_LOG_LIMIT} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_SESSION_NAME" ]; then
        # sed -i -e "s~.*session.name.*~session.name = ${PHP_SESSION_NAME}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[session.name] = ${PHP_SESSION_NAME} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_SESSION_SAVE_HANDLER" ]; then
        # sed -i -e "s~.*session.save_handler.*~session.save_handler = ${PHP_SESSION_SAVE_HANDLER}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[session.save_handler] = ${PHP_SESSION_SAVE_HANDLER} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_SESSION_SAVE_PATH" ]; then
        if [[ ! "$PHP_SESSION_SAVE_PATH" =~ ":" ]]; then
            mkdir -p "${PHP_SESSION_SAVE_PATH}/";
            chown -R ${FPM_USER}:${FPM_GROUP} "${PHP_SESSION_SAVE_PATH}/";
            chmod -R ug+rw "${PHP_SESSION_SAVE_PATH}/";
        fi

        # sed -i -e "s~.*session.save_path.*~session.save_path = ${PHP_SESSION_SAVE_PATH}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[session.save_path] = ${PHP_SESSION_SAVE_PATH} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_SESSION_GC_MAXLIFETIME" ]; then
        # sed -i -e "s~.*session.gc_maxlifetime.*~session.gc_maxlifetime = ${PHP_SESSION_GC_MAXLIFETIME}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[session.gc_maxlifetime] = ${PHP_SESSION_GC_MAXLIFETIME} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_SESSION_GC_PROBABILITY" ]; then
        # sed -i -e "s~.*session.gc_probability.*~session.gc_probability = ${PHP_SESSION_GC_PROBABILITY}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[session.gc_probability] = ${PHP_SESSION_GC_PROBABILITY} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_SESSION_GC_DIVISOR" ]; then
        # sed -i -e "s~.*session.gc_divisor.*~session.gc_divisor = ${PHP_SESSION_GC_DIVISOR}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[session.gc_divisor] = ${PHP_SESSION_GC_DIVISOR} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$PHP_MAX_INPUT_VARS" ]; then
        # sed -i -e "s~.*session.gc_divisor.*~session.gc_divisor = ${PHP_MAX_INPUT_VARS}~g" ${PHP_INI_DIR}/php.ini
        echo php_admin_value[max_input_vars] = ${PHP_MAX_INPUT_VARS} >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if [ ! -z "$SLOWLOG_TIMEOUT" ]; then
        # mkfifo ${SLOW_LOG_STREAM} && chmod 777 ${SLOW_LOG_STREAM}

        sed -i -e "s~;slowlog = .*~slowlog = ${SLOW_LOG_STREAM}~g" ${PHP_INI_DIR}/php-fpm.d/www.conf
        sed -i -e "s/;request_slowlog_timeout = 0s/request_slowlog_timeout = ${SLOWLOG_TIMEOUT}/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    if is_on "$PROXY_VARIABLES_FIXED"; then
        echo 'fastcgi_param REMOTE_ADDR      $x_remote_addr;' >> /etc/nginx/variables.conf
        echo 'fastcgi_param REQUEST_SCHEME   $x_protocol;' >> /etc/nginx/variables.conf
        echo 'fastcgi_param SERVER_PROTOCOL  $x_protocol;' >> /etc/nginx/variables.conf
        echo 'fastcgi_param SERVER_PORT      $x_port;' >> /etc/nginx/variables.conf
    fi

    if is_on "$PHP_ACCESS_LOG"; then
        sed -i -e "s/;access.log*/access.log/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
        if [ "$LOG_FORMAT" = "json" ]; then
            sed -i -e "s/;json.access.format*/access.format/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
        else
            sed -i -e "s/;main.access.format*/access.format/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
        fi
    fi

    if [ ! -z "$PHP_VARIABLES_ORDER" ]; then
        sed -i 's/variables_order = .*/variables_order = "${PHP_VARIABLES_ORDER}"/' ${PHP_INI_DIR}/php.ini
    fi


    if [ ! -z "$OPENSSL_CONF" ]; then
        echo -e "\n${OPENSSL_CONF}" >> /etc/ssl/openssl.cnf
    fi


    dockerize -template /etc/tmpl/nginx/nginx.tmpl > /etc/nginx/nginx.conf

    if [ ! -z "$NGINX_HTTP" ]; then
        sed -i -e "s~include /etc/nginx/http.conf;~# include /etc/nginx/http.conf;~g" /etc/nginx/nginx.conf
    fi

    if [ "$LOG_FORMAT" = "json" ]; then
        sed -i -e "s~include /etc/nginx/log.main.conf;~include /etc/nginx/log.json.conf;~g" /etc/nginx/nginx.conf
    fi

    if [[ $FASTCGI_PASS == "unix:"* ]]; then
        echo "";
    else
        sed -i -e "s/listen.owner*/;listen.owner/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
        sed -i -e "s/listen.group*/;listen.group/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
        sed -i -e "s/listen.mode*/;listen.mode/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
    fi

    # Display Version Details or not
    if is_on "$SHOW_VERSION"; then
        sed -i -e "s/#more_clear_headers Server;//g" /etc/nginx/nginx.conf
        sed -i -e "s/server_tokens off;/server_tokens on;/g" /etc/nginx/nginx.conf
        sed -i -e "s/expose_php = Off/expose_php = On/g" ${PHP_INI_DIR}/php.ini
    else
        if [ ! -z "$RESPONSE_SERVER_NAME" ]; then
            sed -i -e "s/#more_clear_headers Server;/more_set_headers 'Server: ${RESPONSE_SERVER_NAME}';/g" /etc/nginx/nginx.conf
        else
            sed -i -e "s/#more_clear_headers Server;/more_clear_headers Server;/g" /etc/nginx/nginx.conf
        fi
        sed -i -e "s/server_tokens on;/server_tokens off;/g" /etc/nginx/nginx.conf
        sed -i -e "s/expose_php = On/expose_php = Off/g" ${PHP_INI_DIR}/php.ini
    fi

    sed -i -e "s~.*date.timezone.*~date.timezone = ${TZ}~g" ${PHP_INI_DIR}/php.ini

    if [ ! -z "$XDEBUG" ]; then
        if is_on "$XDEBUG"; then
            if [ -f "${PHP_CONF_DIR}/xdebug.ini.stop" ]; then
                mv ${PHP_CONF_DIR}/xdebug.ini.stop ${PHP_CONF_DIR}/xdebug.ini
            fi
        fi
        if is_off "$XDEBUG"; then
            if [ -f "${PHP_CONF_DIR}/xdebug.ini" ]; then
                mv ${PHP_CONF_DIR}/xdebug.ini ${PHP_CONF_DIR}/xdebug.ini.stop
            fi
        fi
    fi

    if [ ! -z "$PHP_LOAD_EXTENSIONS" ]; then
        mv "${PHP_CONF_DIR}/" "${PHP_CONF_DIR}.stop/"
        mkdir "${PHP_CONF_DIR}/"
        a=( $PHP_LOAD_EXTENSIONS )
        for ((j=0; j<"${#a[@]}"; j++)); do
            ext="${a[j]}"
            if [ -f "${PHP_CONF_DIR}.stop/1_$ext.ini" ]; then
                mv "${PHP_CONF_DIR}.stop/1_$ext.ini" "${PHP_CONF_DIR}/1_$ext.ini"
            else
                if [ -f "${PHP_CONF_DIR}.stop/$ext.ini" ]; then
                    mv "${PHP_CONF_DIR}.stop/$ext.ini" "${PHP_CONF_DIR}/$ext.ini"
                else
                    if [ -f "${PHP_CONF_DIR}.stop/z_$ext.ini" ]; then
                        mv "${PHP_CONF_DIR}.stop/z_$ext.ini" "${PHP_CONF_DIR}/z_$ext.ini"
                    fi
                fi
            fi
        done
    fi


    if [ ! -z "$PHP_UNLOAD_EXTENSIONS" ]; then
        mkdir -p "${PHP_CONF_DIR}.stop/"
        a=( $PHP_UNLOAD_EXTENSIONS )
        for ((j=0; j<"${#a[@]}"; j++)); do
            ext="${a[j]}"
            if [ -f "${PHP_CONF_DIR}/1_$ext.ini" ]; then
                mv "${PHP_CONF_DIR}/1_$ext.ini" "${PHP_CONF_DIR}.stop/1_$ext.ini"
            else
                if [ -f "${PHP_CONF_DIR}/$ext.ini" ]; then
                    mv "${PHP_CONF_DIR}/$ext.ini" "${PHP_CONF_DIR}.stop/$ext.ini"
                else
                    if [ -f "${PHP_CONF_DIR}/z_$ext.ini" ]; then
                        mv "${PHP_CONF_DIR}/z_$ext.ini" "${PHP_CONF_DIR}.stop/z_$ext.ini"
                    fi
                fi
            fi
        done
    fi

    # Display PHP error's or not
    if is_on "$DEBUG"; then
        echo php_flag[display_errors] = on >> ${PHP_INI_DIR}/php-fpm.d/www.conf
        # sed -i -e "s/display_errors\s*=\s*.*/display_errors = On/g" ${PHP_INI_DIR}/php.ini
        sed -i -e "s/display_errors\s*=\s*.*/display_errors = stderr/g" ${PHP_INI_DIR}/php.ini
        sed -i -e "s/display_startup_errors\s*=\s*.*/display_startup_errors = On/g" ${PHP_INI_DIR}/php.ini
    else
        echo php_flag[display_errors] = off >> ${PHP_INI_DIR}/php-fpm.d/www.conf
        sed -i -e "s/display_errors\s*=\s*.*/display_errors = Off/g" ${PHP_INI_DIR}/php.ini
    fi

    if [ "$STAGE_NAME" = "production" ]; then
        sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/g" ${PHP_INI_DIR}/php.ini
    else
        sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL/g" ${PHP_INI_DIR}/php.ini
    fi

    #sed -i -e "s~;error_log = php_errors.log~error_log = /proc/self/fd/2~g" ${PHP_INI_DIR}/php.ini
    #sed -i -e "s~;error_log = php_errors.log~error_log = /dev/stderr~g" ${PHP_INI_DIR}/php.ini
    if [ ! -z "$LOG_STREAM" ]; then
        if [[ $LOG_STREAM == "php://"* ]]; then
            echo "";
        else
            mkfifo ${LOG_STREAM} && chmod 777 ${LOG_STREAM}
            sed -i -e "s~;error_log = php_errors.log~error_log = ${LOG_STREAM}~g" ${PHP_INI_DIR}/php.ini

            echo "
[program:php8-cli-log]
command = /usr/bin/tail -f ${LOG_STREAM}
autostart = true
autorestart = true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
" >> /etc/supervisor/conf.d/supervisor.conf
        fi
    fi

    # Increase the memory_limit
    if [ ! -z "$PHP_MEM_LIMIT" ]; then
        sed -i -e "s/.*memory_limit\s*=\s*.*/memory_limit = ${PHP_MEM_LIMIT}/g" ${PHP_INI_DIR}/php.ini
    fi

    # Increase the post_max_size
    if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
        sed -i -e "s/.*post_max_size\s*=\s*.*/post_max_size = ${PHP_POST_MAX_SIZE}/g" ${PHP_INI_DIR}/php.ini
    fi

    # Increase the upload_max_filesize
    if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
        sed -i -e "s/.*upload_max_filesize\s*=\s*.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/g" ${PHP_INI_DIR}/php.ini
    fi

    # cgi.fix_pathinfo off
    # sed -i -e "s/.*cgi.fix_pathinfo\s*=\s*.*/cgi.fix_pathinfo = 0/g" ${PHP_INI_DIR}/php.ini

    dockerize -template /etc/tmpl/nginx/cors.tmpl > /etc/nginx/cors.conf

    if is_off "$NGINX_CORS"; then
        sed -i -e "s~include /etc/nginx/cors.conf;~#include /etc/nginx/cors.conf;~g" /etc/tmpl/nginx/site.https.tmpl
        sed -i -e "s~include /etc/nginx/cors.conf;~#include /etc/nginx/cors.conf;~g" /etc/tmpl/nginx/site.http.tmpl
    fi

    if is_off "$NGINX_ACCESS_LOG"; then
        export NGINX_ACCESS_LOG_LEVEL=" if=\$loggable"
    fi

    mkdir -p /etc/nginx/site.d

    if not_off "$USE_SSL"; then
        domains=$(echo $SSL_DOMAINS | tr ";" "\n")
        for domainName in $domains
        do
            if [ ! -z "$domainName" ]; then
                export SSL_DOMAIN=${domainName}
                dockerize -template /etc/tmpl/nginx/site.https.tmpl > /etc/nginx/site.d/${domainName}.ssl.conf
            fi
        done
    fi

    if [ "$USE_SSL" = "only" ]; then
        dockerize -template /etc/tmpl/nginx/site.default.tmpl > /etc/nginx/site.d/zzz.default.conf
    else
        dockerize -template /etc/tmpl/nginx/site.http.tmpl > /etc/nginx/site.d/default.conf
    fi

    mkdir -p /etc/nginx/common.d/
    dockerize -template /etc/tmpl/nginx/common.d/location.tmpl > /etc/nginx/common.d/location.conf
    dockerize -template /etc/tmpl/nginx/variables.tmpl > /etc/nginx/variables.conf

    rm -rf /etc/tmpl

    php /usr/local/bin/docker-php-env fpm >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    php /usr/local/bin/docker-php-env environment >> /etc/environment

    update-ca-certificates

    if [ ! -z "$COREDUMP" ]; then
        echo '/tmp/core-%e.%p' > /proc/sys/kernel/core_pattern
        echo 0 > /proc/sys/kernel/core_uses_pid
        ulimit -c unlimited
    fi
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
