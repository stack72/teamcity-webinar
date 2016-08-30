#!/bin/bash
export TEAMCITY_DATA_PATH=/opt/TeamCityData
sudo tee /opt/TeamCityData/config/database.properties >/dev/null <<EOF
connectionUrl=jdbc:postgresql://${pg_url}:${pg_port}/${pg_database}
connectionProperties.user=${pg_username}
connectionProperties.password=${pg_password}
EOF
sudo /opt/TeamCity/bin/teamcity-server.sh start
