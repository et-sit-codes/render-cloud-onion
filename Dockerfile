FROM python:3.7-alpine
WORKDIR /
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

## Install build dependencies for docker-gen
RUN apk add --update \
        curl \
        gcc \
        git \
        make \
        musl-dev


RUN apk -U --no-progress upgrade \
 && apk -U --no-progress add tor supervisor

EXPOSE 3030
COPY . .

RUN chmod 700 ./tor_server/hidden_service
CMD python main.py & python3 checker.py && tor -f /code/tor_server/torrc.in