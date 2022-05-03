#!/bin/sh
set -e

cd $(dirname $(readlink -f $0))
./db-wait.sh "$POSTGRES_HOST:$POSTGRES_PORT"
./db-wait.sh "$SOLR_HOST:$SOLR_PORT"

cd ../
bundle exec rails db:prepare
