#!/usr/bin/env bash
 /app/podku -Xms32m -Xmx${MAX_RAM:-512m} -Djdk.xml.maxGeneralEntitySizeLimit=0 -Djdk.xml.totalEntitySizeLimit=0
