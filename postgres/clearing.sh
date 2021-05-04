#!/bin/bash
echo -e "Stoping containers..."
docker-compose -f ./docker-compose.yml down

echo -e "Remove data"
rm -rf pg_data_main/*
rm -rf pg_data_standby/*

echo 'DONE!'