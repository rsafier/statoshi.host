DOCKERFILE=stats.build.all.dockerfile
DOCKERFILE_SLIM=stats.build.slim.dockerfile
DOCKERFILE_EXTRACT=stats.build.all.extract.dockerfile

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

# Note. If you change this, you also need to update docker-compose.yml.
# only useful in a setting with multiple services/ makefiles.
SERVICE_TARGET := main

# if vars not set specifially: try default to environment, else fixed value.
# strip to ensure spaces are removed in future editorial mistakes.
# tested to work consistently on popular Linux flavors and Mac.
ifeq ($(user),)
# USER retrieved from env, UID from shell.
HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),4000))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = $(user)
HOST_UID = $(strip $(if $(uid),$(uid),0))
endif

THIS_FILE := $(lastword $(MAKEFILE_LIST))
CMD_ARGUMENTS ?= $(cmd)

# export such that its passed to shell functions for Docker to pick up.
export PROJECT_NAME
export HOST_USER
export HOST_UID

# all our targets are phony (no files to check).
.PHONY: shell help build rebuild service login test clean prune concat-all concat-slim slim build-all extract run-all run-slim

# suppress makes own output
#.SILENT:

# Regular Makefile part for buildpypi itself
help:
	@echo ''
	@echo 'Usage: make [TARGET] [EXTRA_ARGUMENTS]'
	@echo 'Targets:'
	@echo '  build    	build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  rebuild  	rebuild docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  test     	test docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  service   	run as service --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  login   	run as service and login --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  clean    	remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  prune    	shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo '  shell      run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo ''
	@echo 'Extra arguments:'
	@echo 'cmd=:	make cmd="whoami"'
	@echo '# user= and uid= allows to override current user. Might require additional privileges.'
	@echo 'user=:	make shell user=root (no need to set uid=0)'
	@echo 'uid=:	make shell user=dummy uid=4000 (defaults to 0 if user= set)'

shell:
	bash -c 'cat makefile > makefile.bak'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh
else
	# run the command
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "$(CMD_ARGUMENTS)"
endif

rebuild:
	# force a rebuild by passing --no-cache
	docker-compose -f shell.yml build --no-cache $(SERVICE_TARGET)

service:
	# run as a (background) service
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) up -d $(SERVICE_TARGET)

login: service
	# run as a service and attach to it
	docker exec -it $(PROJECT_NAME)_$(HOST_UID) sh

build:
	# only build the container. Note, docker does this also if you apply other targets.
	docker-compose -f shell.yml build $(SERVICE_TARGET)

clean:
	# remove created images
	@docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'
	rm $(DOCKERFILE) $(DOCKERFILE_SLIM) $(DOCKERFILE_EXTRACT)

prune:
	docker system prune -af

concat-all:
	#concat-all
	bash -c "cat header.dockerfile >              $(DOCKERFILE)"
	bash -c "cat statoshi.build.all.dockerfile >> $(DOCKERFILE)"
	bash -c "cat footer.dockerfile >>             $(DOCKERFILE)"

concat-slim:
	#concat-slim
	bash -c "cat header.slim.dockerfile >         $(DOCKERFILE_SLIM)"
	bash -c "cat statoshi.slim.dockerfile >>      $(DOCKERFILE_SLIM)"
	bash -c "cat footer.dockerfile >>             $(DOCKERFILE_SLIM)"

slim:
	#slim
	$(call cancat-slim)
	docker build -f $(DOCKERFILE_SLIM) --rm -t stats.bitcoincore.dev .

build-all:
	#build-all
	$(call cancat-all)
	docker build -f $(DOCKERFILE) --rm -t stats.bitcoincore.dev .

extract:
	#extract
	$(call build-all)
	sed '$d' $(DOCKERFILE) | sed '$d' | sed '$d' > $(DOCKERFILE_EXTRACT)
		docker build -f $(DOCKERFILE_EXTRACT) --rm -t statoshi.extract .
		docker run --name statoshi.extract  statoshi.extract /bin/true
		docker cp statoshi.extract:/usr/local/bin/bitcoind        $(pwd)/conf/usr/local/bin/bitcoind
		docker cp statoshi.extract:/usr/local/bin/bitcoin-cli     $(pwd)/conf/usr/local/bin/bitcoin-cli
		docker cp statoshi.extract:/usr/local/bin/bitcoin-tx      $(pwd)/conf/usr/local/bin/bitcoin-tx
		docker rm statoshi.extract
		rm -f  $(DOCKERFILE_EXTRACT)

run-all:
	#run-all
	$(call extract)
		docker run --restart always --name stats.bitcoincore.dev -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.bitcoincore.dev .

run-slim:
	#run-slim
	$(call slim)
		docker run --restart always --name stats.bitcoincore.dev -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.bitcoincore.dev .

test:
	#test
	# here it is useful to add your own customised tests
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
