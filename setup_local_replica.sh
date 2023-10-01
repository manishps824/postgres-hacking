instance_data_dir=$1
instance_port=$2
primary_port=$3
replica_user=replica_user
myname=$(basename "$0")

if [ $# -eq 0 ]; then
    >&2 echo "No arguments provided"
    echo "Usage: $myname <data_dir_path> <port_number> <primary_port_number>"
    exit 1
fi



if [ -z $instance_data_dir ]; then
	>&2 echo "Data Directory  not  specified. Aborting."
	exit  1
fi

data_dir=/pgsql/data/$instance_data_dir/
archive_dir=/pgsql/archive

if [ -d $data_dir ]; then
	>&2 echo "Directory $data_dir already present! Aborting"
	exit 1
fi

mkdir -p $data_dir
chmod 700 $data_dir
rm -rf $data_dir/*

pg_basebackup --pgdata $data_dir --format=p --checkpoint=fast --progress --host=127.0.0.1 --port=$primary_port --username=$replica_user

{
echo "port=$instance_port"
echo "logging_collector = on"
echo "log_destination = stderr"
echo "log_filename = 'postgresql_%A-%d-%B_%H%M'"
echo "log_directory=log"
echo "primary_conninfo='user=$replica_user password=welcome port=$primary_port host=127.0.0.1 application_name=$instance_data_dir.repl'"
echo "restore_command='cp $archive_dir/%f %p'"
} >> $data_dir/postgresql.conf

touch $data_dir/standby.signal
pg_ctl -D $data_dir start

