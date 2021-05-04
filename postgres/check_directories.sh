#!/bin/bash

echo "Creating needeble folders"
if [ -d ./pg_data_main ] && [ -d ./pg_data_standby ]
then
    echo "Directories exist"
else
    echo "Directories don't exist. Creating directories"
    mkdir pg_data_main && mkdir pg_data_standby
fi