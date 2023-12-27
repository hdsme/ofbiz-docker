#!/bin/bash
ConfFile=framework/entity/config/entityengine.xml
cd /ofbiz
source /.env

checkcontent=`grep -n "  runtimeOnly" build.gradle`
if [ $? = 0 ] ; then
        line=`grep -n "  runtimeOnly" build.gradle | cut -d : -f 1 | head -1`
        sed -i "$line"i" runtimeOnly 'mysql:mysql-connector-java:5.1.49'" build.gradle
        sed -i "$line"i" runtimeOnly 'org.postgresql:postgresql:42.2.5.jre7'" build.gradle
     else
          line=`grep -n "   runtime" build.gradle | cut -d : -f 1 | head -1`
          sed -i "$line"i" runtime 'mysql:mysql-connector-java:5.1.49'" build.gradle
          sed -i "$line"i" runtime 'org.postgresql:postgresql:42.2.5.jre7'" build.gradle
fi

sed -i 's/jdbc-uri="jdbc:postgresql:\/\/.*"/jdbc-uri="jdbc:postgresql:\/\/'$DB_HOST'\/'$POSTGRES_DB'"/g' $ConfFile
sed -i 's/jdbc-username=".*"/jdbc-username="'$POSTGRES_USER'"/g' $ConfFile
sed -i 's/jdbc-password=".*"/jdbc-password="'$POSTGRES_PASSWORD'"/g' $ConfFile
sed -i -e '40,80s/localderby/'local$DB_TYPE'/g' $ConfFile
sed -i -e '350,572s/127.0.0.1/'$DB_HOST'/g' $ConfFile

sed -i 's/port.https.enabled=.*/port.https.enabled='N'/g' framework/webapp/config/url.properties
sed -i 's/no.http=.*/no.http='Y'/g' framework/webapp/config/url.properties
sed -i 's/port.http=.*/port.http='80'/g' framework/webapp/config/url.properties # HTTP
sed -i 's/force.http.host=.*/force.http.host='localhost'/g' framework/webapp/config/url.properties
sed -i 's/port.https=.*/port.https='443'/g' framework/webapp/config/url.properties # HTTPS
sed -i 's/force.https.host=.*/force.https.host='localhost'/g' framework/webapp/config/url.properties
sed -i 's/host-headers-allowed=.*/host-headers-allowed='localhost,127.0.0.1,demo-trunk.ofbiz.apache.org,demo-stable.ofbiz.apache.org,demo-next.ofbiz.apache.org'/g' framework/security/config/security.properties

