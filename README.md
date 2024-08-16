# PySpark-Sedona-Delta Docker Environment

## **About The Project**

This project provides an easy-to-deploy environment for running geospatial processing jobs using the Python programming language with the power of Apache Spark, enhanced by the Sedona library for geospatial analytics and Delta Lake for reliable data storage.
</br>


### **Built With**
[![Docker][Docker]][Docker-url]
</br>

### **Dependencies**
- [Apache Spark](https://spark.apache.org/)
- [Sedona](https://sedona.apache.org/1.4.1/)
- [Delta Lake](https://delta.io/)


## **Getting Started**

Check out the following [project](https://github.com/Raychani1/PySpark_Sedona_Delta_Test) for usage example.

### **Prerequisites**

* **Docker** - To use this environment an installed copy of Docker is required. For this purpose [**Docker**](https://www.docker.com/) or [**Docker Desktop**](https://www.docker.com/products/docker-desktop/) is recommended. The following product can be downloaded from their website or installed through a package manager.

### Building the image locally

1. Clone the repo and navigate to the Project folder
   ```sh
   git clone https://github.com/Raychani1/PySpark_Sedona_Delta_Docker
   ```

2. Build the Docker Image
   ```sh
   docker build -t pyspark_sedona_delta_docker .
   ```

3. Navigate to your Project directory and create a Project related Dockerfile based on the new Image with the following content:
    ```sh
   FROM pyspark_sedona_delta_docker:latest

   WORKDIR /app

   # Install Project related Python libraries
   COPY requirements.txt .
   RUN pip install -r requirements.txt --no-cache-dir
    ```

4. Build the Project related Docker Image
   ```sh
   docker build -t my_project .
   ```

5. Create alternative way for more convenient execution

   On Linux:
   ```sh
   alias My_Project="docker run --rm -it -v $(pwd):/app my_project:latest"
   ```

   On Windows:
   1. Create a PowerShell script file with the following content:
      ```sh
      function My_Project {
         docker run --rm -it -v ${pwd}:/app my_project:latest $args    
      }
      ```

   2. Load the new function using the dot notation
      ```sh
      . .\my_project.ps1
      ```

6. Run your project through the environment
   ```sh
   My_Project python main.py
   ```

### Pulling image from Docker Hub

1. Navigate to your Project directory and create a Project related Dockerfile based on the new Image with the following content:
    ```sh
   FROM rajcsanyiladislavit/local_geo_analysis:latest 

   WORKDIR /app

   # Install Project related Python libraries
   COPY requirements.txt .
   RUN pip install -r requirements.txt --no-cache-dir
    ```

2. Follow steps 4 - 6 in the [previous section](#building-the-image-locally).

### Developing your code in a Dev Container

1. Navigate to your Project directory and create a Project related Dockerfile based on the description in [previous section(s)](#pulling-image-from-docker-hub).

2. Start up your Project container and connect to it using the official documentation for [VS Code](https://code.visualstudio.com/docs/devcontainers/containers) and [PyCharm](https://www.jetbrains.com/help/pycharm/connect-to-devcontainer.html#start_from_gateway).



## **License**

Distributed under the **MIT License**. See [LICENSE](https://github.com/Raychani1/PySpark_Sedona_Delta_Docker/blob/main/LICENSE) for more information.

</br>

<!-- Variables -->

[Docker]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-url]: https://www.docker.com/
