PGDATA=/pgsql/data
PGLOG=/pgsql/log
{
echo "logging_collector=on"
echo "log_destination='stderr'"
echo "log_rotation_age=1d"
echo "log_directory='$PGLOG'"
echo "log_line_prefix = '%m [%p] %q%u@%d '"
echo "port=5678"
} >> $PGDATA/postgresql.conf
