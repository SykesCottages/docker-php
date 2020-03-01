# Sykes Cottages Base Docker Image

## About

We use a variety of PHP containers at Sykes Cottages across most of our platforms, but due to a lot of bespoke requirements in our applications using the official PHP images typically required a monalithic Dockerfile to support the application.
All of our PHP images are based off the [Base Sykes](https://github.com/SykesCottages/docker-base) image which uses the official Ubuntu Docker image.
We opted for this path to utilise aptitude so we could manage packages easier and utilise the package integrity verification that comes with apititude.

## Usage

Pulling an image:
```
docker pull sykescottages/php:version
```

Running an container:
```
docker run -it sykescottages/php:version
```

Building from this image simply reference it as part of your Dockerfile:

```
FROM sykescottages/php:version

# ... Your configuration
```

## Testing

All testing is done in the form of a SUT containers which is run by the Docker Hub (see [Automated repository tests](https://docs.docker.com/docker-hub/builds/automated-testing/) for more information) and runs a variety of shell scripts.

## Contributions

Contributions are welcome, but please adhere to the [CONTRIBUTION.MD](https://github.com/SykesCottages/docker-php/blob/master/CONTRIBUTION.MD). Also, if you could ensure that there are tests with every modification of the Dockerfiles to verify that your changes work.
