# Symfony starter

## Presentation

Generate a fresh dockerized Symfony project, with docker compose in another directory.

> This project [use a fork](git@github.com:jprivet-dev/symfony-docker) and a modified version of [Symfony Docker](https://github.com/dunglas/symfony-docker), which can be used in another folder.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation
 
* `git clone git@github.com:jprivet-dev/symfony-starter.git`
* `cd symfony-starter`
* `make init` or `. scripts/init.sh`:
  * That clone `git@github.com:jprivet-dev/symfony-docker` in `docker` directory
  * Build fresh images
  * Set up and start a fresh Symfony project in `app` directory
  * Fix permissions
* Go on https://symfony-starter.localhost
* See all shorcuts for the most common tasks with `$ make`
* You can then stop or restart the project:
  * `$ make stop` 
  * `$ make start` 


## Resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/jprivet-dev/symfony-docker
- https://medium.com/@unhandlederror/how-to-run-docker-compose-from-another-directory-e94e081a80cc

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).