#!/bin/sh
set -e

if [ -n "$DATABASE_URL" ]; then
  echo "Applying Prisma migrations..."
  max_attempts=30
  attempt=0
  until bunx prisma migrate deploy >/tmp/prisma-migrate.log 2>&1; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge "$max_attempts" ]; then
      echo "ERROR: database not ready after $attempt attempts. Check DATABASE_URL and database connectivity."
      echo "--- Prisma Migration Error Log ---"
      cat /tmp/prisma-migrate.log
      echo "----------------------------------"
      exit 1
    fi
    echo "Waiting for database to become available (attempt $attempt/$max_attempts)..."
    sleep 2
  done
else
  echo "WARNING: DATABASE_URL is not set. Skipping Prisma migrations."
fi

exec "$@"
