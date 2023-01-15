DEPENDENCY_OWNER=$(shell cat .env | grep DEPENDENCY_OWNER | cut -d= -f2)
DEPENDENCY_GIT=$(shell cat .env | grep DEPENDENCY_GIT | cut -d= -f2)
PROJECT_OWNER=$(shell cat .env | grep PROJECT_OWNER | cut -d= -f2)
PROJECT_GIT=$(shell cat .env | grep PROJECT_GIT | cut -d= -f2)


.PHONY: build, upload, reset, up, down


build:
	export DOCKER_BUILDKIT=1 && \
		docker build -t fe-link \
		-f Dockerfile \
		--ssh default="${HOME}/.ssh/id_rsa" \
		--build-arg DEPENDENCY_OWNER=${DEPENDENCY_OWNER} \
		--build-arg DEPENDENCY_GIT=${DEPENDENCY_GIT} \
		--build-arg PROJECT_OWNER=${PROJECT_OWNER} \
		--build-arg PROJECT_GIT=${PROJECT_GIT} \
	    . && \
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

