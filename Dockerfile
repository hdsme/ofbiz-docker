# OpenJdk IMAGE
FROM openjdk:8-jdk-alpine

MAINTAINER Hao Hoang

# Install necessary packages and desirable debug tools
RUN apk update && \
    apk upgrade && \
    apk add git && \
    apk add bash && \
    apk add subversion && \
    apk add mysql-client

COPY .env entrypoint.sh .

# Clone release18.12 version
RUN git clone -b release18.12 https://github.com/apache/ofbiz-framework ofbiz_erp

# Expose service ports
EXPOSE 8443
EXPOSE 8080
RUN ./entrypoint.sh  && sleep 2  && tail -f /ofbiz_erp/runtime/logs/ofbiz.log && bash

# Start ERP
WORKDIR /ofbiz_erp
RUN ./gradlew loadAll
ENTRYPOINT ./gradlew ofbiz