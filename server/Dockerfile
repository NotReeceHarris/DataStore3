FROM python:3.9

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

COPY . /server
WORKDIR /server

CMD [ "python", "./server.py" ]
