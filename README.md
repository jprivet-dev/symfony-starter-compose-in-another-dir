# Symfony starter

## Presentation

Generate a fresh Symfony application, with the Docker configuration in a parallel directory.

> This project [use a fork](git@github.com:jprivet-dev/symfony-docker) and a modified version of [Symfony Docker](https://github.com/dunglas/symfony-docker), which can be used in another folder.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation
 
- `git clone git@github.com:jprivet-dev/symfony-starter.git`
- `cd symfony-starter`
- `make init`:
  - That clone `git@github.com:jprivet-dev/symfony-docker` in `docker/`.
  - Build fresh images.
  - Generate a fresh Symfony application in `app/`.
  - Fix permissions.
- Go on https://symfony-starter.localhost.

# Start/Stop the project

- `make start`
- `make stop`
- `make restart`

> See all shorcuts for the most common tasks with `make`.

## Structure

### Before `make init`

```
./
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

### After `make init`

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

- If you don't have access to `make`, use [scripts/init.sh](scripts/init.sh) instead of `make init`:
  - `. scripts/init.sh`
  - `. scripts/init.sh origin/next`

## Resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/jprivet-dev/symfony-docker
- https://medium.com/@unhandlederror/how-to-run-docker-compose-from-another-directory-e94e081a80cc

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).