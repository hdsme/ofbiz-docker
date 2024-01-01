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

# Clone release18.12 version
RUN git clone -b release18.12 https://github.com/apache/ofbiz-framework ofbiz_erp

WORKDIR /ofbiz_erp/
COPY .env entrypoint.sh .
RUN chmod +x entrypoint.sh

# Expose service ports
EXPOSE 8443
EXPOSE 8080

# Start
WORKDIR /ofbiz_erp/
RUN ./entrypoint.sh
RUN ./gradlew loadAll
ENTRYPOINT ./gradlew ofbiz && sleep 2  && tail -f /ofbiz_erp/runtime/logs/ofbiz_erp.log && bash