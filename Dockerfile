FROM golang:alpine as builder

WORKDIR /app

#COPY . /app/

#RUN apk update \
#  && apk add gcc musl-dev postgresql-dev postgresql-client

#RUN pip3 install --upgrade pip \
#  && pip3 install --trusted-host pypi.python.org pipenv

go build -o artifact/osspharm


FROM alpine:latest as prod

WORKDIR /app

COPY --from=builder artifact/osspharm /app/

CMD /app/osspharm
