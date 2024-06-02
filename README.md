
## JMS Bridge Graphana Demo - Docker Compose Installation

### Overview
The JMS-Bridge is a component that can be used to facilitate quicker migration from legacy JMS based systems to ones built around the Confluent Platform:
<br >[https://www.confluent.io/confluent-accelerators/](https://www.confluent.io/confluent-accelerators/)
<br />(See **JMS 2.0 Bridge** section)

This JMS Bridge Graphana Demo runs the JMS Bridge in a Docker Compose along with Confluent Platform and Grapha, and includes a use case for geographical visual of airport traveler events in a Graphana Dashboard.
![Graphana](./jms-bridge-graphana-demo/images/graphan-dashboard.png)

### Installation - Prerequisites
The Confluent JMS Bridge Docker Images are required, these are not publicly available but can be obtained from Confluent CSID Team, typically as ```jms-bridge-docker.tar```. They are referenced as ```placeholder/confluentinc/jms-bridge-docker:local.build``` in Docker Compose. They should be loaded in Docker before starting JMS Bridge Graphana Demo for the first time for example:
```shell
docker load < jms-bridge-docker.tar
```

### Docker Compose Deployment
Deploy the attached ```docker-compose.yaml```:
```shell
# In the same directory as docker-compose.yaml
docker compose up -d
```

### Confirm Confluent Platform is Running
Navigate to Confluent Control Center to verify Confluent Platform:
<br />[http://localhost:9021](http://localhost:9021)
<br />(Note - Replace ```localhost``` with the IP or DNS name where Docker is running)
<br />You should see one Healthy Cluster running in Confluent Platform, named ```controlcenter.cluster```

### Create Travel Topic
In Confluent Control Center, navigate to the ```controlcenter.cluster``` Cluster and create a new topic named as ```psy-travel```, with all the default values.

### Restart
On the command line, restart JMS Bridge to sync up with the newly created topic:
```shell
docker restart jms-bridge-psy
```
### Create the ksqlDB Streams for Graphana Visualization
In Confluent Control Center, navigate to ksqlDB in the ```controlcenter.cluster``` Cluster and create the following Streams:

**Create stream to base ROWTIME calculations for downstream processing**
```sql
CREATE STREAM T1_JSON (id VARCHAR, first_name VARCHAR, last_name VARCHAR, gender VARCHAR, age VARCHAR, eyecolor VARCHAR, email VARCHAR, phone_number VARCHAR, street_address VARCHAR, state VARCHAR, zip_code VARCHAR, country VARCHAR, country_code VARCHAR, airport VARCHAR, status VARCHAR)
WITH (KAFKA_TOPIC='psy-travel', VALUE_FORMAT='JSON');
```

**Create persistent query with formatted ROWTIME for Graphana Dashboard**
```sql
CREATE STREAM USER_EVENTS_AVRO WITH (VALUE_FORMAT='AVRO') AS
SELECT ROWTIME AS ts, TIMESTAMPTOSTRING(ROWTIME, 'yyyy-MM-dd HH:mm:ss.SSS z') AS rowtime_formatted, *
FROM T1_JSON PARTITION by id;
```
### Create a Confluent Connect PostgreSQL Sink Connector to Power the Graphana Dashboard
On the command line, Install Kafka Connect JDBC:
```shell
# Connect to Confluent Connect container
docker exec -it connect-psy /bin/bash
# Install Kafka Connect JDBC and exit
confluent-hub install confluentinc/kafka-connect-jdbc:10.7.5
exit
# Restart Confluent Connect to load the new connector
docker restart connect-psy
```
In Confluent Control Center, deploy the Sink Connector for PostgreSQL:
1. Navigate to Connect in the ```controlcenter.cluster``` Cluster:
1. Select the ```connect-default``` Cluster
1. Click [+Add connector] button
1. Click [Upload connector config file] button
1. Upload the attached ```connect-jdbc-sink.json``` file
1. Click [Next] button and Deploy the connector

### Create the Graphana Dashboard
Navigate to Graphana:
<br />[http://localhost:3000](http://localhost:3000)
<br />(Note - Replace ```localhost``` with the IP or DNS name where Docker is running)
<br />Upload attached ```PSY Traveler Events Dashboard-1712964241310.json``` Dashboard.

### Generate Sample Events
Use the JMS Client of your choice to generate sample events from the attached ```psy_travelers.txt```:
```yaml
- jms.host: tcp://localhost:61616
- jms.topicName kafka.psy-travel
```
(Note - Replace ```localhost``` with the IP or DNS name where Docker is running)

### Refresh the Graphana Dashboard
Navigate to Graphana:
<br />[http://localhost:3000](http://localhost:3000)
<br />(Note - Replace ```localhost``` with the IP or DNS name where Docker is running)
<br />Open the ```PSY Traveler Events Dashboard``` Dashboard. You should see events visualized on the dashboard per the messages produced from ```psy_travelers.txt```.

### JMS Bridge Architecture
![Graphana](./jms-bridge-graphana-demo/images/jms-bridge-arch.png)
