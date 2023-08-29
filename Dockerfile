ARG PYTHON_VERSION=3.9.5
FROM python:${PYTHON_VERSION}

# Set default values for Library/Tool versions
ARG SCALA_VERSION=2.12
ARG HADOOP_VERSION=3.3.4
ARG SEDONA_VERSION=1.4.1
ARG DELTA_CORE_VERSION=2.4.0
ARG GEOTOOLS_WRAPPER_VERSION=1.4.0-28.2

WORKDIR /app

# Set Environmental Variables
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
ENV HADOOP_HOME="/usr/hadoop"
ENV SPARK_HOME="/usr/local/lib/python3.9/site-packages/pyspark"
ENV PYSPARK_PYTHON="python3"
ENV SPARK_LOCAL_IP="localhost"
ENV PATH="$PATH:$JAVA_HOME/bin:$SPARK_HOME/bin:$HADOOP_HOME/bin"

# Install OpenJDK 11
RUN apt-get update && apt-get --no-install-recommends install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*

# Setup Python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install Python libraries
COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir

# Setup Hadoop
RUN wget "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" -q --show-progress \
 && tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" \
 && rm "/app/hadoop-${HADOOP_VERSION}.tar.gz" \
 && mv "/app/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}"

# Setup PySpark with Delta
RUN wget "https://repo1.maven.org/maven2/io/delta/delta-core_${SCALA_VERSION}/${DELTA_CORE_VERSION}/delta-core_${SCALA_VERSION}-${DELTA_CORE_VERSION}.jar" -q --show-progress \
 && mv "/app/delta-core_${SCALA_VERSION}-${DELTA_CORE_VERSION}.jar" "${SPARK_HOME}/jars/delta-core_${SCALA_VERSION}-${DELTA_CORE_VERSION}.jar"

RUN wget "https://repo1.maven.org/maven2/io/delta/delta-storage/${DELTA_CORE_VERSION}/delta-storage-${DELTA_CORE_VERSION}.jar" -q --show-progress \
 && mv "/app/delta-storage-${DELTA_CORE_VERSION}.jar" "${SPARK_HOME}/jars/delta-storage-${DELTA_CORE_VERSION}.jar"

# Setup PySpark with Sedona
RUN wget "https://dlcdn.apache.org/sedona/${SEDONA_VERSION}/apache-sedona-${SEDONA_VERSION}-bin.tar.gz" -q --show-progress \
 && tar -xzf "apache-sedona-${SEDONA_VERSION}-bin.tar.gz" \
 && rm "apache-sedona-${SEDONA_VERSION}-bin.tar.gz" \
 && mv "/app/apache-sedona-${SEDONA_VERSION}-bin/sedona-spark-shaded-3.0_${SCALA_VERSION}-${SEDONA_VERSION}.jar" "${SPARK_HOME}/jars/sedona-spark-shaded-3.0_${SCALA_VERSION}-${SEDONA_VERSION}.jar" \
 && rm -rf "/app/apache-sedona-${SEDONA_VERSION}-bin/"

RUN wget "https://repo1.maven.org/maven2/org/datasyslab/geotools-wrapper/${GEOTOOLS_WRAPPER_VERSION}/geotools-wrapper-${GEOTOOLS_WRAPPER_VERSION}.jar" -q --show-progress \
 && mv "/app/geotools-wrapper-${GEOTOOLS_WRAPPER_VERSION}.jar" "${SPARK_HOME}/jars/geotools-wrapper-${GEOTOOLS_WRAPPER_VERSION}.jar"

