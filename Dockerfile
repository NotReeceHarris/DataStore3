FROM python:3.9-alpine

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY . /server
WORKDIR /server

ENTRYPOINT ["./gunicorn.sh"]
