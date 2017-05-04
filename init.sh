#!/bin/bash

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
su -g mysql -s /bin/bash -c /usr/bin/mysqld mysql &
MARIA_PID=$!

sleep 2 #Wait for mariadb to spin up

sed -e 's/^#\(.*\)$/\1/m' /var/lib/tomcat8/webapps/rs/ddl/reportserver-RS3.0.2-5855-schema-MySQL5_CREATE.sql | mysql -u root


CATALINA_PID=/var/run/tomcat8.pid
TOMCAT_JAVA_HOME=/usr/lib/jvm/default-runtime
CATALINA_HOME=/usr/share/tomcat8
CATALINA_BASE=/usr/share/tomcat8
CATALINA_OPTS=
ERRFILE=SYSLOG
OUTFILE=SYSLOG

#Start tomcat
echo "STARTING TOMCAT"
/usr/bin/jsvc \
            -Dcatalina.home=${CATALINA_HOME} \
            -Dcatalina.base=${CATALINA_BASE} \
            -Djava.io.tmpdir=/var/tmp/tomcat8/temp \
            -cp /usr/share/java/commons-daemon.jar:/usr/share/java/eclipse-ecj.jar:${CATALINA_HOME}/bin/bootstrap.jar:${CATALINA_HOME}/bin/tomcat-juli.jar \
            -java-home ${TOMCAT_JAVA_HOME} \
            -pidfile /var/run/tomcat8.pid \
            -errfile ${ERRFILE} \
            -outfile ${OUTFILE} \
            $CATALINA_OPTS \
            org.apache.catalina.startup.Bootstrap


wait #for mariadb

#Stop tomcat
/usr/bin/jsvc \
            -pidfile /var/run/tomcat8.pid \
            -stop \
            org.apache.catalina.startup.Bootstrap
