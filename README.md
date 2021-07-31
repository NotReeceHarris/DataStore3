<p align="center"> <img src="https://i.imgur.com/pch9ykm.png" width="180" hight="180"> </p>

***

## Docker run

### Build
```bash
docker build -t flask/flask_docker .
```

### Run
change `80` to your selected port
```bash
docker run -d -p 80:80 flask/flask_docker.
```
