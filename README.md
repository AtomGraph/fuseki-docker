# fuseki-docker
Docker image for Apache Jena's Fuseki SPARQL endpoint

Usage example:

    docker run --rm atomgraph/fuseki --mem /ds

Arguments after the image name (`atomgraph/fuseki`) become arguments to the [Fuseki server](https://jena.apache.org/documentation/fuseki2/fuseki-run.html#fuseki-standalone-server).