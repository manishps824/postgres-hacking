#!/bin/bash
primary_data_dir=$1
replica_data_dir=$2
if [ $# -eq 0 ]; then
    >&2 echo "No arguments provided"
    echo "Usage: $myname primary_data_dir_subfolder replica_data_dir_subfolder. The base directory used is /pgsql/data. Run this script as postgres OS user"
    exit 1
fi

if [ -z $primary_data_dir ]; then
	echo "Primary Data Dir sub folder not specified. Aborting."
	exit  1
fi

if [ -z $replica_data_dir ]; then
	echo "Replica Data Dir sub folder not specified. Aborting."
	exit  1
fi

echo "Setting up primary instance at folder /pgsql/data/$primary_data_dir at port 5433"
rm -rf /pgsql/data/$1;bash setup_local_primary.sh $1 5433

echo "Setting up replica instance at folder /pgsql/data/$replica_data_dir at port 5434"
rm -rf /pgsql/data/$2;bash setup_local_replica.sh $2 5434 5433


