# FROM python:3.9.5
FROM python:3.9.5-alpine3.12

WORKDIR /app

# Setup PySpark Environment
# RUN apt-get update && apt-get install -y openjdk-11-jdk wget
RUN apk add --update --no-cache make automake gcc g++ subversion openjdk11 wget geos-dev
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# ENV PYTHONUNBUFFERED=1
# RUN apk add --update --no-cache python3=3.9.5 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install Python libraries
COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir

ENV SPARK_HOME="/usr/local/lib/python3.9/site-packages/pyspark"
ENV HADOOP_HOME="/usr/local/lib/python3.9/site-packages/pyspark"
ENV PATH="$PATH:$JAVA_HOME/bin:$SPARK_HOME/bin:$HADOOP_HOME/bin"
ENV PYSPARK_PYTHON="python3"
ENV SPARK_LOCAL_IP="localhost"

# Setup PySpark with Delta
RUN wget https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar
RUN wget https://repo1.maven.org/maven2/io/delta/delta-storage/2.4.0/delta-storage-2.4.0.jar
RUN mv /app/delta-core_2.12-2.4.0.jar ${SPARK_HOME}/jars/delta-core_2.12-2.4.0.jar
RUN mv /app/delta-storage-2.4.0.jar ${SPARK_HOME}/jars/delta-storage-2.4.0.jar

# Setup PySpark with Sedona
RUN wget https://dlcdn.apache.org/sedona/1.4.1/apache-sedona-1.4.1-bin.tar.gz 
RUN tar -xvzf apache-sedona-1.4.1-bin.tar.gz
RUN mv /app/apache-sedona-1.4.1-bin/sedona-spark-shaded-3.0_2.12-1.4.1.jar ${SPARK_HOME}/jars/sedona-spark-shaded-3.0_2.12-1.4.1.jar
RUN rm apache-sedona-1.4.1-bin.tar.gz
RUN rm -rf /app/apache-sedona-1.4.1-bin/

RUN wget https://repo1.maven.org/maven2/org/datasyslab/geotools-wrapper/1.4.0-28.2/geotools-wrapper-1.4.0-28.2.jar 
RUN mv /app/geotools-wrapper-1.4.0-28.2.jar ${SPARK_HOME}/jars/geotools-wrapper-1.4.0-28.2.jar
