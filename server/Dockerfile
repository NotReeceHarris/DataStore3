FROM python:3.9

COPY requirements.txt /
RUN sudo python -m pip install -r /requirements.txt

COPY . /server
WORKDIR /server

CMD [ "sudo", "python", "./server.py" ]
