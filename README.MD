# Sykes Cottages PHP Docker Images

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
docker run -i -t sykescottages/php:version
```

Building from this image simply reference it as part of your Dockerfile:

```
FROM sykescottages/php:version

# ... Your configuration
```

## Composer

All images come with composer installed, but by default they all use version 1 which stops legacy composer builds from failing. 
To replace composer or use a specific version of composer you will need to extend this image and create a multi-stage build Dockerfile e.g. 

```dockerfile
FROM sykescottages/php:7.4-cli
COPY --from=composer /usr/bin/composer /usr/bin/composer
```

## Supported versions and available tags
- php5.6-cli - `sykescottages/php:5.6-cli`
- php5.6-fpm - `sykescottages/php:5.6-fpm`
- php7.0-cli - `sykescottages/php:7.0-cli`
- php7.0-fpm - `sykescottages/php:7.0-fpm`
- php7.1-cli - `sykescottages/php:7.1-cli`
- php7.1-fpm - `sykescottages/php:7.1-fpm`
- php7.2-cli - `sykescottages/php:7.2-cli`
- php7.2-fpm - `sykescottages/php:7.2-fpm`
- php7.3-cli - `sykescottages/php:7.3-cli`
- php7.3-fpm - `sykescottages/php:7.3-fpm`
- php7.4-cli - `sykescottages/php:7.4-cli`
- php7.4-fpm - `sykescottages/php:7.4-fpm`
- php8.0-cli - `sykescottages/php:8.0-cli`
- php8.0-fpm - `sykescottages/php:8.0-fpm`
- php8.1-cli - `sykescottages/php:8.1-cli`
- php8.1-fpm - `sykescottages/php:8.1-fpm`


## Testing

All testing is done in the form of a SUT containers which is run by the Docker Hub (see [Automated repository tests](https://docs.docker.com/docker-hub/builds/automated-testing/) for more information) and runs a variety of shell scripts.

## Installing extensions

As these images are using the `ondrej` repositories you can install extensions with aptitude e.g.

```shell script
# Installation requires auto confirmation, the -q flag is optional
RUN apt-get update && \
    apt-get install -y -q \
        php8.0-memcache

# Good practice to reduce image size
RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*
```

With all images (apart from the base) there is a pre-canned set of extensions:
- bcmath
- curl
- dev
- intl
- json
- mbstring
- mysql
- soap
- xml
- zip

## Removing Extensions

If you did want to remove these extensions the can be adding the following your `Dockerfile`:
```shell script
# Installation requires auto confirmation, the -q flag is optional
RUN apt-get remove --purge -y php8.0-mysql \
  apt-get autoremove -y -q && \
  apt-get autoclean -y -q
```

## Contributions

Contributions are welcome, but please adhere to the [CONTRIBUTION.MD](https://github.com/SykesCottages/docker-php/blob/master/CONTRIBUTION.MD). Also, if you could ensure that there are tests with every modification of the Dockerfiles to verify that your changes work.
