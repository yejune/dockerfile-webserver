
ext-lib unixodbc-dev
ln -fs /usr/lib/x86_64-linux-gnu/libodbc.a /usr/local/lib/odbclib.a

mkdir /usr/local/incl
cp /usr/include/sqlext.h /usr/local/incl/

ext-src odbc
