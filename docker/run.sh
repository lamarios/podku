#!/usr/bin/env bash
 java -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -Djdk.xml.maxGeneralEntitySizeLimit=0 -Djdk.xml.totalEntitySizeLimit=0 -jar /app/podku.jar