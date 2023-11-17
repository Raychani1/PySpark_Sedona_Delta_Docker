ARG PYTHON_VERSION=3.9.5
FROM python:${PYTHON_VERSION}

# Set default values for Library/Tool versions
ARG PYTHON_BASE_VERSION=3.9
ARG PYSPARK_VERSION=3.4.0
ARG HADOOP_VERSION=3.3.4

WORKDIR /app

# Set Environmental Variables
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
ENV HADOOP_HOME="/usr/hadoop"
ENV SPARK_HOME="/usr/local/lib/python$PYTHON_BASE_VERSION/site-packages/pyspark"
ENV PYSPARK_PYTHON="python3"
ENV SPARK_LOCAL_IP="localhost"
ENV PATH="$PATH:$JAVA_HOME/bin:$SPARK_HOME/bin:$HADOOP_HOME/bin"

# Install OpenJDK 11
RUN apt-get update && apt-get --no-install-recommends install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*

# Setup Python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install Python libraries
RUN pip install pyspark==${PYSPARK_VERSION} --no-cache-dir

# Setup Hadoop
RUN wget "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" -q --show-progress \
 && tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" \
 && rm "/app/hadoop-${HADOOP_VERSION}.tar.gz" \
 && mv "/app/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}"