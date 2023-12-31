# OpenJdk IMAGE
FROM adoptopenjdk/openjdk11:latest

MAINTAINER Hao Hoang

# Install necessary packages and desirable debug tools
RUN apt -y update && \
    apt -y upgrade && \
    apt install -y git && \
    apt install -y bash && \
    apt install -y subversion && \
    apt install -y mysql-client && \
    apt install -y postgresql && \
    apt install -y postgresql-contrib

COPY .env entrypoint.sh .

# Clone release18.12 version
RUN git clone -b release18.12 https://github.com/apache/ofbiz-framework ofbiz_erp

# Expose service ports
EXPOSE 8443
EXPOSE 8080
RUN chmod +x ./entrypoint.sh
RUN ./entrypoint.sh
# && sleep 2  && tail -f /ofbiz_erp/runtime/logs/ofbiz.log && bash

# Start ERP
WORKDIR /ofbiz_erp
RUN ./gradlew loadAll
ENTRYPOINT ./gradlew ofbiz