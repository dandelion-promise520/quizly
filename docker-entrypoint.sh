#!/bin/sh
set -e

if [ -n "$DATABASE_URL" ]; then
  echo "Applying Prisma migrations..."
  until bunx prisma migrate deploy >/dev/null 2>&1; do
    echo "Waiting for database to become available..."
    sleep 2
  done
else
  echo "WARNING: DATABASE_URL is not set. Skipping Prisma migrations."
fi

exec "$@"
