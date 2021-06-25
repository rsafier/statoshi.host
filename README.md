--
## Docker Notes & [DigitalOcean.com](https://m.do.co/c/ae5c7d05da91)

## [stats.bitcoincore.dev](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages/314536)

#### Full Build

This runs the statoshi configuration and [displays statsd data from the pruned node](http://stats.bitcoincore.dev:3000).

```
docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev
0.20.99             a27f8eb4ad39        4 minutes ago       2.98GB
```

Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:0.20.99

Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:0.20.99


## [stats.bitcoincore.dev.slim](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages/315130)

#### Slim Build

This runs the slim (precompiled signed binaries) configuration and [displays statsd data from the pruned node](http://stats.bitcoincore.dev:3000).

```
docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim
0.20.99             390876b14625        24 minutes ago      1.63GB
```
Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim:0.20.99

Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim:0.20.99

## [stats.bitcoincore.dev.gui](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages/315116)

#### Gui Build

This runs the gui [(graphite/grafana) configuration](http://stats.bitcoincore.dev:3000) and pulls data from
[http://stats.bitcoincore.dev:8080](http://stats.bitcoincore.dev:8080). Useful as a demo or if you don't want to run your own statoshi instance.

```
docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.gui
0.20.99             737a8acf33c5        About an hour ago   1.23GB
```

Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.gui:0.20.99
	
Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.gui:0.20.99

## make help


##### $ <code>make</code>

	[ARGUMENTS]	
      args:
        - HOME=/Users/git
        - PWD=/Users/git/stats.bitcoincore.dev
        - UMBREL=false
        - THIS_FILE=GNUmakefile
        - TIME=1624610130
        - HOST_USER=root
        - HOST_UID=0
        - PUBLIC_PORT=80
        - NODE_PORT=8333
        - SERVICE_TARGET=shell
        - ALPINE_VERSION=3.11.6
        - WHISPER_VERSION=1.1.7
        - CARBON_VERSION=1.1.7
        - GRAPHITE_VERSION=1.1.7
        - STATSD_VERSION=0.8.6
        - GRAFANA_VERSION=7.0.0
        - DJANGO_VERSION=2.2.24
        - PROJECT_NAME=stats.bitcoincore.dev
        - DOCKER_BUILD_TYPE=all
        - SLIM=false
        - DOCKERFILE=stats.bitcoincore.dev
        - DOCKERFILE_BODY=docker/statoshi.all
        - GIT_USER_NAME=randymcmillan
        - GIT_USER_EMAIL=randy.lee.mcmillan@gmail.com
        - GIT_SERVER=https://github.com
        - GIT_PROFILE=bitcoincore-dev
        - GIT_BRANCH=master
        - GIT_HASH=2f2b7a730c7b12025c3f693523e3e46807329868
        - GIT_REPO_ORIGIN=git@github.com:bitcoincore-dev/stats.bitcoincore.dev.git
        - GIT_REPO_NAME=stats.bitcoincore.dev
        - GIT_REPO_PATH=/Users/git/stats.bitcoincore.dev
        - DOCKERFILE=stats.bitcoincore.dev
        - DOCKERFILE_PATH=/Users/git/stats.bitcoincore.dev/stats.bitcoincore.dev
        - BITCOIN_CONF=/Users/git/stats.bitcoincore.dev/conf/bitcoin.conf
        - BITCOIN_DATA_DIR=/Users/git/.bitcoin
        - STATOSHI_DATA_DIR=/Users/git/.statoshi
        - NOCACHE=
        - VERBOSE=
        - PUBLIC_PORT=80
        - NODE_PORT=8333
        - PASSWORD=changeme
        - CMD_ARGUMENTS=

	[USAGE]:	make [BUILD] run [EXTRA_ARGUMENTS]	

		make init header build run user=root uid=0 nocache=false verbose=true

	[DEV ENVIRONMENT]:	

		make header user=root
		make shell  user=root
		make shell  user=root

	[EXTRA_ARGUMENTS]:	set build variables	

		nocache=true
		            	add --no-cache to docker command and apk add 
		port=integer
		            	set PUBLIC_PORT default 80

		nodeport=integer
		            	set NODE_PORT default 8333

		            	TODO

	[DOCKER COMMANDS]:	push a command to the container	

		cmd=command 	
		cmd="command"	
		             	send CMD_ARGUMENTS to the [TARGET]

	[EXAMPLE]:

		make all run user=root uid=0 no-cache=true verbose=true
		make report all run user=root uid=0 no-cache=true verbose=true cmd="top"
		make a r port=80 no-cache=true verbose=true cmd="ls"

	[COMMAND_LINE]:

	stats-console              # container command line
	stats-bitcoind             # start container bitcoind -daemon
	stats-debug                # container debug.log output
	stats-whatami              # container OS profile

	stats-cli -getmininginfo   # report mining info
	stats-cli -gettxoutsetinfo # report txo info

	#### WARNING: (effects host datadir) ####
	
	stats-prune                # default in bitcoin.conf is prune=1 - start pruning node
	
