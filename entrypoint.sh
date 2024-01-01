#!/bin/bash
source .env
cd /ofbiz_erp


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

sed -i 's/jdbc-uri="jdbc:postgresql:\/\/.*"/jdbc-uri="jdbc:postgresql:\/\/'$DB_HOST'\/'$DB_NAME'"/g' framework/entity/config/entityengine.xml
sed -i 's/jdbc-username=".*"/jdbc-username="'$DB_USER'"/g' framework/entity/config/entityengine.xml
sed -i 's/jdbc-password=".*"/jdbc-password="'$DB_PASSWORD'"/g' framework/entity/config/entityengine.xml
sed -i -e '40,80s/localderby/'local$DB_TYPE'/g' framework/entity/config/entityengine.xml
sed -i -e '350,572s/127.0.0.1/'$DB_HOST'/g' framework/entity/config/entityengine.xml

sed -i 's/port.https.enabled=.*/port.https.enabled='$HTTPS_ENABLED'/g' framework/webapp/config/url.properties
sed -i 's/no.http=.*/no.http='$HTTP_ENABLED'/g' framework/webapp/config/url.properties
sed -i 's/port.http=.*/port.http='$HTTP_PORT'/g' framework/webapp/config/url.properties
sed -i 's/force.http.host=.*/force.http.host='$HTTP_HOST'/g' framework/webapp/config/url.properties
sed -i 's/port.https=.*/port.https='$HTTP_PORTS'/g' framework/webapp/config/url.properties
sed -i 's/force.https.host=.*/force.https.host='$HTTPS_HOST'/g' framework/webapp/config/url.properties
sed -i 's/host-headers-allowed=.*/host-headers-allowed='$HOST_CORS'/g' framework/security/config/security.properties

./gradlew loadAll
./gradlew ofbiz