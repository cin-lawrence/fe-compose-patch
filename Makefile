.PHONY: build, upload, reset, up, down


build:
	export DOCKER_BUILDKIT=1 && docker build -t ffg_fe -f Dockerfile --ssh default="${HOME}/.ssh/id_rsa" .
	docker-compose build

uplog:
	docker-compose up -d && docker-compose logs -f app

reset:
	docker-compose down && docker-compose up -d

up:
	docker-compose up -d

down:
	docker-compose down

clean:
	docker-compose down --remove-orphans -v

all: build up

