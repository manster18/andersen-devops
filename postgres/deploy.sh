#!/bin/bash

POSTGRES_DB=test_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_REPLICATION_USER=replication
POSTGRES_REPLICATION_PASSWORD=password

echo "Creating needeble folders"
if [ -d ./pg_data_main ] && [ -d ./pg_data_standby ]
then
    echo "Directories already exist"
else
    echo "Directories don't exist. Creating directories"
    mkdir pg_data_main && mkdir pg_data_standby
fi

echo "Starting docker compose"
docker-compose -f ./docker-compose.yml up -d > /dev/null 2>&1
docker stop postgres_standby_1  # we will run it later
sleep 5 && rm -rf $PWD/pg_data_standby/* > /dev/null 2>&1

#Primary Postgresql DB

echo "Change primary postgres db configuration"
while [ ! -f $PWD/pg_data_main/pg_hba.conf ]; do sleep 1; done
	echo "host replication all 0.0.0.0/0 trust" >> $PWD/pg_data_main/pg_hba.conf \ # For the replication
    echo "host test_db all 0.0.0.0/0 trust" >> $PWD/pg_data_main/pg_hba.conf \ #for the Adminer
cp $PWD/async_conf/postgres_primary_async.conf $PWD/pg_data_main/postgresql.conf
# Change files owner to postgres
docker exec -it postgres_primary_1 su $POSTGRES_USER -c "chown -R postgres.postgres /var/lib/postgresql/data"

until docker exec -ti postgres_primary_1 su $POSTGRES_USER -c 'pg_isready' ; do
    sleep 5;
done

echo -e "Restart primary Postgres container..."
docker restart postgres_primary_1 > /dev/null 2>&1

until docker exec -ti postgres_primary_1 su $POSTGRES_USER -c 'pg_isready' ; do
    sleep 5;
done

echo "Create replication user"

docker exec -i postgres_primary_1 psql -t postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost/$POSTGRES_USER <<EOF
        CREATE ROLE ${POSTGRES_REPLICATION_USER} WITH LOGIN PASSWORD '${POSTGRES_REPLICATION_PASSWORD}' REPLICATION;;
EOF

echo "Cloning data for standby server"
docker exec -it postgres_primary_1 pg_basebackup -h postgres_primary_1 -D /backup -P -R -U $POSTGRES_USER --wal-method=stream
docker exec -it postgres_primary_1 su postgres -c "/usr/lib/postgresql/11/bin/pg_ctl reload"

echo "Change stanby postgres db configuration"
cp $PWD/async_conf/postgres_standby_async.conf $PWD/pg_data_standby/recovery.conf

echo 'Starting standby Postgres container'
docker start postgres_standby_1 > /dev/null 2>&1

until docker exec -ti postgres_standby_1 su postgres -c 'pg_isready' ; do
    sleep 5;
done

echo "Test replication status on primary Postgres..."

docker exec -it postgres_primary_1 su $POSTGRES_USER -c \
"psql -U postgres -d test_db -c 'SELECT pid,usename,application_name,state,sync_state FROM pg_stat_replication;'"