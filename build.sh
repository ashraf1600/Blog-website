#!/usr/bin/env bash
set -o errexit

pip install --upgrade pip
pip install -r requirements.txt

python manage.py collectstatic --no-input
python manage.py migrate

#!/usr/bin/env bash

# Exit on error
set -o errexit

# Install dependencies (use pip, poetry, or whatever you use)
pip install -r requirements.txt

# Run database migrations
python manage.py migrate --no-input

# --- Superuser Creation (Temporary Block) ---
if [[ "$CREATE_SUPERUSER" ]]; then
  # Createsuperuser reads the credentials from the environment variables (DJANGO_SUPERUSER_*)
  python manage.py createsuperuser --no-input
  echo "Superuser creation initiated."
fi
# ---------------------------------------------

# Collect static files
python manage.py collectstatic --no-input

# The rest of your build script continues...