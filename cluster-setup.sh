PGBIN=/usr/local/pgsql/bin
PGDATA=/pgsql/data
PGWAL=/pgsql/pg_wal
PGLOG=/pgsql/log
CURDIR=`pwd`
sudo rm -rf /pgsql
sudo useradd -U -m -r -s /bin/bash postgres
sudo mkdir -p /pgsql
sudo mkdir -p /pgsql/data /pgsql/pg_wal /pgsql/log
sudo chown postgres:postgres /pgsql/*
sudo rm -rf /pgsql/data/* /pgsql/pg_wal/*  /pgsql/log/*
sudo su - postgres -c "$PGBIN/initdb -D $PGDATA -X $PGWAL"
sudo cp $CURDIR/configure-logging.sh /tmp/configure-logging.sh
sudo chmod 777 /tmp/configure-logging.sh
sudo su - postgres -c "bash /tmp/configure-logging.sh"
sudo su - postgres -c "$PGBIN/pg_ctl -D $PGDATA -l /tmp/initial_start start"
