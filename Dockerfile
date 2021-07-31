FROM python:3.6.12-alpine

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY . /server
WORKDIR /server

ENTRYPOINT ["./gunicorn.sh"]
