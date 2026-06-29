#!/bin/sh
set -e

# Ensure the database directory exists
mkdir -p /app/data

# Create database file if it does not exist
if [ ! -f /app/data/quiz.db ]; then
  echo "Initializing empty database file..."
  touch /app/data/quiz.db
fi

# Symlink quiz.db to the root directory where the application expects it
ln -sf /app/data/quiz.db /app/quiz.db

# Run database push to apply schema
echo "Applying database schema..."
npx prisma db push --accept-data-loss

# Execute the container's CMD
exec "$@"
