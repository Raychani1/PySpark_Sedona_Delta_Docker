ARG PYTHON_VERSION=3.9.5
ARG PYSPARK_VERSION=3.4.0
FROM local_pyspark:Py_${PYTHON_VERSION}_Spark_${PYSPARK_VERSION}

# Set default values for Library/Tool versions
ARG SCALA_VERSION=2.12
ARG HADOOP_VERSION=3.3.4
ARG SEDONA_VERSION=1.4.1
ARG DELTA_CORE_VERSION=2.4.0
ARG GEOTOOLS_WRAPPER_VERSION=1.4.0-28.2

WORKDIR /app

# Install Python libraries
COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir

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
