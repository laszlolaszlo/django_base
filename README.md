# Django 4.0.X based image

This is a Django 4.0.X based image. I made some modifications on default settings.
- Custom USer Model (accouns app)
- Whitenoise static files handling
- Crispy Forms with BootStrap 5 support
- Argon2 password hash
- Virtualenv in Docker image

## Prereq

You have to Docker and python3 with virtualenv and pip module installed.

## Easy to use with docker compose

You don't need to clone the whole repository. You need only the docker-compose.yaml file. Run **docker compose** command from your application source code root folder. In docker-compose.yaml there is a **volume** which mount your source code into the container. Beacause **--reload** command attribute Gunicorn app server inside the container will be reload itself when you change your source code.

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

You havew to run **makemigrations** and **migrate** after container starts.  

```bash
docker compose -f docker-compose.yaml exec web python manage.py makemigrations
docker compose -f docker-compose.yaml exec web python manage.py migrate
```
