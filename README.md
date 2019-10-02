# fuseki-docker
Docker image for Apache Jena's [Fuseki](https://jena.apache.org/documentation/fuseki2/) (v2) triplestore server

## Endpoints

In the following examples which use `/ds` as the dataset path, these main endpoints are available:

* http://localhost:3030/ds/sparql for SPARQL Query
* http://localhost:3030/ds/update for SPARQL Update
* http://localhost:3030/ds/data for Graph Store (read-write)
* http://localhost:3030/ds/get for Graph Store (read-only)

They can be redefined in [configuration](https://jena.apache.org/documentation/fuseki2/fuseki-configuration.html#defining-the-service-name-and-endpoints-available).

Post 3030 has to be [mapped](https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose) to be able to access it on the Docker host.

## Usage

Arguments after the image name (`atomgraph/fuseki`) become arguments to the [Fuseki server (no UI)](https://jena.apache.org/documentation/fuseki2/fuseki-run.html#fuseki-server). As the name explains, this server version _does not include the user interface_.

### Examples

Empty memory dataset:

    docker run --rm -p 3030:3030 atomgraph/fuseki --mem /ds

Dataset from file `data.nt` (which is mounted as part of the current directory):

    docker run --rm -p 3030:3030 -v $(pwd):/usr/share/data atomgraph/fuseki --file=/usr/share/data/data.nt /ds

Help (all run options explained):

    docker run --rm atomgraph/fuseki --help
