# GA Postgres Base Image

> ~~Base Image used for ga-db~~
#### _`This is now no longer needed as we don't use postgres with flyway. Instead we are now using RDS posgres instance behind Django.`_


Base image used for spinning up the container for postgres database 

## Installing & getting started

> Run the following steps to get base image available

1) Clone this Repo
2) Run the docker build and run commands
   * docker build -t ga-postgres-db:v1 .
   * docker run -ti ga-postgres-db
3) List the Docker processes to see the container ID of your last running container
   * docker ps -l
4) Login to quay.io
   * docker login quay.io
5) Commit your docker instance with the ID that you saw running
   * docker commit XXXXXXXXXXXX quay.io/ukhomeofficedigital/ga-postgres-db:v1.1
      * where XXXXXXXXXXXX is the container id
6) Push the container to quay.io
   * docker push quay.io/ukhomeofficedigital/ga-postgres-db:v1.1

> This container should then be available for use as the base image for postgres
containers.
