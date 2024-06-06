
## JMS Bridge Graphana Demo - Docker Compose Installation

### Overview
The JMS-Bridge is a component that can be used to facilitate quicker migration from legacy JMS based systems to ones built around the Confluent Platform:
<br >[https://www.confluent.io/confluent-accelerators/](https://www.confluent.io/confluent-accelerators/)
<br />(See **JMS 2.0 Bridge** section)

This JMS Bridge Graphana Demo runs the JMS Bridge in a Docker Compose along with Confluent Platform and Grapha, and includes a use case for geographical visual of airport traveler events in a Graphana Dashboard.
![Graphana](./jms-bridge-graphana-demo/images/graphan-dashboard.png)

### Installation - Prerequisites

### Installation 
To be able to deploy and execute the JMS Bridge Graphana Demo, the following prerequisites are required:

First, create a file called `values.tfvars` with the following content in the same directory as `docker-compose.yaml`:
```shell
confluent_cloud_api_key="<confluent_cloud_api_key>"
confluent_cloud_api_secret="<confluent_cloud_api_secret>"
confluent_cloud_provider="<confluent_cloud_provider[AWS|GCP|AZURE]>"
confluent_cloud_region="<confluent_cloud_region>"
confluent_cloud_environment_name="<confluent_cloud_environment_name>"
confluent_cloud_cluster_name="<confluent_cloud_cluster_name>"
confluent_cloud_cluster_type="basic"
confluent_cloud_topic_names=["psy-travel"]
```

Then run the following command to deploy the JMS Bridge Graphana Demo:
```shell
cd jms-bridge-graphana-demo
./deploy.sh
```

### Producing Sample Events

To produce sample events, run the following command:

```shell
cd jms-bridge-graphana-demo
./produce.sh
```

//TODO