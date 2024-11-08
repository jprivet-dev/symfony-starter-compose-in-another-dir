# Symfony starter

## Presentation

Generate a fresh Symfony application, with the Docker configuration in a parallel directory.

> This project [use a fork](git@github.com:jprivet-dev/symfony-docker) and a modified version of [Symfony Docker](https://github.com/dunglas/symfony-docker), which can be used in another folder.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation
 
- `git clone git@github.com:jprivet-dev/symfony-starter.git`
- `cd symfony-starter`
- `make generate`:
  - That clone `git@github.com:jprivet-dev/symfony-docker` in `docker/`.
  - Build fresh images.
  - Generate a fresh Symfony application in `app/`.
  - Fix permissions.
- Go on https://symfony-starter.localhost.

> 

# Start/Stop the project (Docker)

- `make start`
- `make stop`
- `make restart`

> See all shorcuts for the most common tasks with `make`.

## Structure

### Before `make generate`

```
./
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

### After `make generate`

```
./
├── app/       <-- Fresh Symfony application
├── docker/    <-- Fresh Docker configuration (in a parallel directory to app/)
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

## Save all after installation

### `app/`

To save the generated Symfony application:

- Remove `app/` from [.gitignore](.gitignore).
- `git add . && git commit -m "Fresh Symfony application"`

### `docker/`

To save the Docker configuration:

- Remove `docker/` from [.gitignore](.gitignore).
- `rm -Rf docker/.git`
- `git add . && git commit -m "Fresh Docker configuration"`

## Tips

- If you don't have access to `make`, use [scripts/generate.sh](scripts/generate.sh) instead of `make generate`:
  - `. scripts/generate.sh`
  - `. scripts/generate.sh origin/next`

## Troubleshooting

### Error listen tcp4 0.0.0.0:80: bind: address already in use

If you have the following error:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

See the network statistics:

```shell
sudo netstat -pna | grep :80
```

```
tcp6       0      0 :::80        :::*        LISTEN        4321/apache2
...
...
```

For example, in that previous case `.../apache2`, stop Apache server:

```shell
sudo service apache2 stop
````

## Editing permissions on Linux

If you work on linux and cannot edit some of the project files right after the first installation, you can run in that project `make permissions`, to set yourself as owner of the project files that were created by the docker container.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md

## Resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md
- https://github.com/jprivet-dev/symfony-docker
- https://medium.com/@unhandlederror/how-to-run-docker-compose-from-another-directory-e94e081a80cc

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).