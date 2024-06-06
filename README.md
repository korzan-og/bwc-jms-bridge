
## JMS Bridge Grafana Demo

### Overview
The JMS-Bridge is a component that can be used to facilitate quicker migration from legacy JMS based systems to ones built around the Confluent Platform:
<br >[https://www.confluent.io/confluent-accelerators/](https://www.confluent.io/confluent-accelerators/)
<br />(See **JMS 2.0 Bridge** section)

This JMS Bridge Grafana Demo runs the JMS Bridge in a Docker Compose along with Confluent Cloud, Grafana with the KSQL plugin , and includes a use case for geographical visual of airport traveler events in a Grafana Dashboard.
![Grafana](./jms-bridge-grafana-demo/images/grafan-dashboard.png)

### The JMS Bridge Grafana Demo includes the following components:

- **Confluent Cloud**: A fully managed Apache Kafka service.
- **JMS Bridge**: A component that can be used to facilitate quicker migration from legacy JMS based systems to ones built around the Confluent Platform.
- **Grafana**: A multi-platform open-source analytics and interactive visualization web application.
- **KSQL Plugin for Grafana**: A Grafana plugin that allows you to query and visualize data from Confluent Cloud using KSQL.

### Installation - Prerequisites

To run this demo, you need to have the following installed on your machine:

* Docker

### Installation 
First, create a file called `values.tfvars` with the following content in the same directory as `docker-compose.yml`:
```shell
confluent_cloud_api_key="<confluent_cloud_api_key>"
confluent_cloud_api_secret="<confluent_cloud_api_secret>"
confluent_cloud_provider="<confluent_cloud_provider[AWS|GCP|AZURE]>"
confluent_cloud_region="<confluent_cloud_region>"
confluent_cloud_environment_name="<confluent_cloud_environment_name>"
confluent_cloud_cluster_name="<confluent_cloud_cluster_name>"
```

Then run the following command to deploy the JMS Bridge Grafana Demo
```shell
cd jms-bridge-grafana-demo
./deploy.sh
```

### Usage

To produce messages, run the following command:
```shell
cd jms-bridge-grafana-demo
./produce.sh
```

Now you can access the Grafana Dashboard by visiting [http://localhost:3000](http://localhost:3000) and select the `PSY Traveler Events Dashboard` in the Dashboards section.

![Dashboard](./jms-bridge-grafana-demo/images/grafana.png)

### Cleanup

To stop and remove the containers, run the following command:
```shell
cd jms-bridge-grafana-demo
./destroy.sh
```