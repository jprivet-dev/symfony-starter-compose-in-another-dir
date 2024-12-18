# Symfony starter - Compose in another directory

## Presentation

Generate a fresh Symfony application, with the Docker configuration in a parallel directory.

The aim is to be able to generate a project that **clearly separates responsibilities**, between what concerns the Symfony application and what concerns its dockerization.

> This project is a variant of [Symfony stater](https://github.com/jprivet-dev/symfony-starter), and use a specific version of [Symfony Docker](https://github.com/dunglas/symfony-docker) : 
> - https://github.com/jprivet-dev/symfony-docker/tree/compose-in-another-dir.
> - [See the diff with main...compose-in-another-dir](https://github.com/jprivet-dev/symfony-docker/compare/main...jprivet-dev:symfony-docker:compose-in-another-dir)

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation
 
- `git clone git@github.com:jprivet-dev/symfony-starter-compose-in-another-dir.git`
- `cd symfony-starter-compose-in-another-dir`
- `make generate`:
  - That clone `git@github.com:jprivet-dev/symfony-docker` in `docker/`.
  - Build fresh images.
  - Generate a fresh Symfony application in `app/`.
  - Fix permissions.
- Go on https://symfony-starter-compose-in-another-dir.localhost/.

All in one:

```shell
git clone git@github.com:jprivet-dev/symfony-starter-compose-in-another-dir.git \
&& cd symfony-starter-compose-in-another-dir \
&& make generate
```

## Clean all and generate again

```shell
# 1. Stop the container
make stop

# 2. Remove app/ and docker/ directories
make clean

# 3. Generate again
make generate
```

## Start and stop the project (Docker)

```shell
make start
make stop
make restart
```

> Run `make` to see all shorcuts for the most common tasks.

## Structure

Before `make generate`:

```
./
├── overload/
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

After `make generate`:

```
./
├── app/       <-- Fresh Symfony application
├── docker/    <-- Fresh Docker configuration
├── overload/
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

## Save all after installation

### Save the generated Symfony application (`app/`):

1. Remove `app/` from [.gitignore](.gitignore).
2. `git add . && git commit -m "Fresh Symfony application"`

### Save the Docker configuration (`docker/`)

1. Remove `docker/` from [.gitignore](.gitignore).
2. `docker/.git` is already removed on `make generate` command.
3. Remove the following block from [docker/frankenphp/docker-entrypoint.sh](docker/frankenphp/docker-entrypoint.sh) :
```shell
	# Install the project the first time PHP is started
	# After the installation, the following block can be deleted
	if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project "symfony/skeleton $SYMFONY_VERSION" tmp --stability="$STABILITY" --prefer-dist --no-progress --no-interaction --no-install
		# ...
	fi
```
4. `git add . && git commit -m "Fresh Docker configuration"`

## Makefile: variables overloading

You can choose an another branch of my forked Symfony Docker repository, or customize the docker build process. To do this, create an `overload/.env` file and override the following variables :

```dotenv
# overload/.env

# See https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir/branches
BRANCH=next

# See https://docs.docker.com/compose/how-tos/project-name/
PROJECT_NAME=my-project

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
COMPOSE_UP_SERVER_NAME=my.localhost
COMPOSE_UP_ENV_VARS=SYMFONY_VERSION=6.4.* HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443

# See https://docs.docker.com/reference/cli/docker/compose/build/#options
COMPOSE_BUILD_OPTS=--no-cache
```

These variables will be taken into account by the `make` commands.

> As the variables are common to the `Makefile` and `docker compose`, I'm not attaching an environment file with the `--env-file` option at the moment. See https://docs.docker.com/compose/how-tos/environment-variables/.

## Shortcomings of this approach

Putting Docker in another folder, outside the application, prevents the use of [Flex Recipes & Docker Configuration](https://symfony.com/doc/current/setup/docker.html#flex-recipes-docker-configuration).

⏱️ Search for a solution underway...

## Troubleshooting

### Error "address already in use" or "port is already allocated"

See [Symfony starter project](https://github.com/jprivet-dev/symfony-starter?tab=readme-ov-file#error-address-already-in-use-or-port-is-already-allocated).

### Editing permissions on Linux

If you work on linux and cannot edit some of the project files right after the first installation, you can run in that project `make permissions`, to set yourself as owner of the project files that were created by the docker container.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md

## Resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md
- https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
- https://github.com/jprivet-dev/symfony-docker
- https://github.com/jprivet-dev/makefiles
- https://medium.com/@unhandlederror/how-to-run-docker-compose-from-another-directory-e94e081a80cc

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir/blob/main/LICENSE).