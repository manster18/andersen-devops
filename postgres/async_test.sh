#!/bin/bash

COUNT=999999
if [ ! -z "$1" ]; then COUNT=$1 ; fi

#cp $PWD/pg_main_async.conf $PWD/pg_data_main/postgresql.conf
#cp $PWD/pg_standby_async.conf $PWD/pg_data_standby/postgresql.conf
#docker exec -it pg_main su postgres -c "pg_ctl reload" 2>&1>/dev/null
#docker exec -it pg_standby su postgres -c "pg_ctl reload" 2>&1>/dev/null

echo "Checking replication state"
docker exec -it postgres_primary_1 su postgres -c \
"psql -U postgres -d test_db -c 'SELECT pid,usename,application_name,state,sync_state FROM pg_stat_replication;'"

echo "Create table for the test"
docker exec -it postgres_primary_1 su postgres -c \
"psql -U postgres -d test_db -c 'create table test (column_1 integer, column_2 text);'"

echo "Generating data"
docker exec -it postgres_primary_1 su postgres -c \
"psql -U postgres -d test_db -c 'explain analyze insert into test
select x, md5(random()::text) from generate_series(1, $COUNT) as x;'"

echo "Checking replication lag"
for run in {1..4};
do 
  docker exec -it postgres_primary_1 su postgres -c \
  "psql -U postgres -d test_db -c 'SELECT write_lag,flush_lag,replay_lag FROM pg_stat_replication;'"
  sleep 7
done
