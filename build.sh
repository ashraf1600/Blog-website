#!/usr/bin/env bash

# Exit on error
set -o errexit

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Clean previous static files to avoid conflicts
rm -rf staticfiles

# Run database migrations
python manage.py migrate --no-input

# Collect static files (do this AFTER migrations)
python manage.py collectstatic --no-input --clear

echo "Build completed successfully!"