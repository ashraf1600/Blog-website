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

# Superuser creation (optional)
if [[ "$CREATE_SUPERUSER" ]]; then
  python manage.py createsuperuser --no-input
  echo "Superuser created successfully."
fi
```

## Key Changes:

1. **Removed duplicate shebang and commands** - You had two `#!/usr/bin/env bash` lines and duplicate `collectstatic` commands
2. **Added `rm -rf staticfiles`** - Cleans old static files before collecting new ones
3. **Added `--clear` flag** - Ensures clean collection of static files
4. **Reordered operations** - Migrations before collectstatic is the standard order

## On Render Dashboard:

Make sure you have these **Environment Variables** set if you want the superuser creation to work:
```
CREATE_SUPERUSER=true
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=your_secure_password
```

## Also Check:

Your **Render Build Command** should be:
```
./build.sh
```

And your **Start Command** should be:
```
gunicorn blog.wsgi:application