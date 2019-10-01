# Use base image's tag name
FROM python:3.7-alpine
MAINTAINER Shabie Iqbal

# Needed to avoid complications of running python in a container
ENV PYTHONUNBUFFERED 1

# Copy from our directory to the image
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# Create extra user that it only has rights to run the app. No root access!
RUN adduser -D user
USER user
