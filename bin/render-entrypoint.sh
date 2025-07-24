#!/usr/bin/env sh
# exit on error
set -o errexit

rm -f /app/tmp/pids/server.pid

echo "Waiting for database to be ready..."
ruby -r pg -e "
  retries = 5
  begin
    PG.connect(ENV['DATABASE_URL'])
    puts 'Database is ready!'
  rescue PG::ConnectionBad
    puts 'Database not ready yet, retrying...'
    retries -= 1
    if retries > 0
      sleep 5
      retry
    else
      exit 1
    end
  end
"

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Running database seeds..."
bundle exec rails db:seed

exec "$@"
