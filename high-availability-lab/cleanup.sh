#!/bin/bash
pg_ctl -D /pgsql/data/$1 stop
pg_ctl -D /pgsql/data/$2 stop
rm -rf /pgsql/data/$1
rm -rf /pgsql/data/$2
rm -rf /pgsql/archive/*
