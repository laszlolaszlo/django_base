ARG ARCH=
###########
# BUILDER #
###########
# pull official base image
FROM ${ARCH}python:3.10.5-alpine3.16 as builder

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN apk update && apk upgrade --no-cache && apk add python3-dev libpq gcc zlib-dev jpeg-dev tiff-dev musl-dev libffi-dev freetype lcms2 libwebp-dev tcl-dev openjpeg-dev libimagequant-dev fribidi-dev libxcb-dev
RUN python -m pip install wheel
COPY ./requirements.txt .
RUN python -m pip wheel --no-cache-dir --wheel-dir /usr/src/app/wheels -r requirements.txt

#########
# FINAL #
#########
# pull official base image
ARG ARCH=
FROM ${ARCH}python:3.10.5-alpine3.16
# Install dependecies for Pillow and Django dbshell
RUN apk update && apk upgrade --no-cache && apk add libjpeg openjpeg libimagequant tiff libxcb postgresql14-client

# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN addgroup -S app && adduser -S app -G app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/staticfiles
WORKDIR $APP_HOME

# install dependencies
COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/requirements.txt .
RUN pip install --no-cache /wheels/*

# copy entrypoint.sh
COPY ./entrypoint.sh /
RUN sed -i 's/\r$//g'  /entrypoint.sh
RUN chmod +x  /entrypoint.sh && chown app:app /entrypoint.sh

# copy project
COPY . $APP_HOME

# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

# run entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
