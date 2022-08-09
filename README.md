# Django 4.0.X based image

This is a Django 4.0.X based image. I made some modifications on default settings.
- Custom USer Model (accouns app)
- Whitenoise static files handling
- Crispy Forms with BootStrap 5 support
- Argon2 password hash

## Easy to use with docker compose

```yaml
version: '3.8'

services:
  web:
    image: laszlolaszlo/django_base:latest
    command: gunicorn app.wsgi:application --bind 0.0.0.0:8000 --reload --timeout=5 --threads=10 --workers=1
    volumes:
      - ./:/home/app/web/
    ports:
      - "8000:8000"
    env_file:
      - ./.env.dev
```