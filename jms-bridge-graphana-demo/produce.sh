#!/usr/bin/env sh

echo "[+] Producing messages to JMS Bridge every 2 seconds"
java -jar jms-mutator-1.0-SNAPSHOT.jar ./psy_travelers.txt 2000
