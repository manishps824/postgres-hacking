instance_data_dir=$1
instance_port=$2
replica_user=replica_user
archive_dir=/pgsql/archive
data_dir=/pgsql/data/$instance_data_dir/
cur_dir=`pwd`
template_dir=$cur_dir/templates
myname=$(basename "$0")

if [ $# -eq 0 ]; then
    >&2 echo "No arguments provided"
    echo "Usage: $myname <data_dir_path> <port_number>"
    exit 1
fi

if [ -z $instance_data_dir ]; then
	echo "Data Directory  not  specified. Aborting."
	exit  1
fi

if [ -d $data_dir ]; then
	echo "Directory $data_dir already present! Aborting"
	exit 1
fi

mkdir -p $data_dir
mkdir -p $archive_dir
rm -rf $data_dir/*
rm -rf $archive_dir/*

initdb -D $data_dir

{
echo "port=$instance_port"
echo "logging_collector = on"
echo "log_destination = stderr"
echo "log_filename = 'postgresql_%A-%d-%B_%H%M'"
echo "log_directory=log"
echo "archive_mode=on"
echo "archive_command='cp %p $archive_dir/%f'"
} >> $data_dir/postgresql.conf

cp $template_dir/pg_hba.conf $data_dir/pg_hba.conf

pg_ctl -D $data_dir start
echo "CREATE ROLE $replica_user WITH REPLICATION LOGIN PASSWORD 'welcome';"
psql -h 127.0.0.1 -p $instance_port -U  postgres  postgres -c "CREATE ROLE $replica_user WITH REPLICATION LOGIN PASSWORD 'welcome';"

