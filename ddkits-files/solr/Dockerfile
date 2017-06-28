
FROM solr:5.5.4-alpine

# We just add a core with the search_api_solr config to the
# base image here.
RUN mkdir -p /opt/solr/server/solr/ddkits-files/data
ADD conf/ /opt/solr/server/solr/ddkits-files/conf/
ADD core.properties /opt/solr/server/solr/ddkits-files/core.properties