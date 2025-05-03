MAKE := make

ifeq ($(OS),Windows_NT) 
detected_OS := Windows
else
detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif
$(info "$(detected_OS)")

ifeq ($(OS),Windows_NT)
cwd := $(shell pwsh -c '($$(PWD).Path) || echo Unknown')
else
cwd := $(shell sh -c '${PWD} || pwd || echo Unknown')
endif

run:
	bun run dev

start:
	bun run start

install:
	bun install || npm install

build:
	(bun install && bun run build:bun:debug) || (npm install -force && npm run build:npm:debug)

release:
	bun run build:bun || npm run build

debug:
	bun run build:bun:debug || npm run build:npm:debug

format:
	bun run fmt

clean:
	bun run clean || npm run clean

upgrade:
	bun update || npx npm-check-updates -u

docker:
	docker build -t tauri --output type=local,dest=./out/ . || sudo docker build -t tauri --output type=local,dest=./out/ .

dagger:
ifeq ($(detected_OS),Linux)
	cd .ci && ./dagger.sh
endif
ifeq ($(detected_OS),Darwin)
	cd .ci && ./dagger.sh
endif
ifeq ($(detected_OS),Windows)
	cd .ci && pwsh ./dagger.ps1
endif

flox:
	(sudo docker run --pull always -v $(cwd):/smdc_portal -v $(cwd)/.flox/build/zshrc:/root/.zshrc -v /var/run/docker.sock:/var/run/docker.sock --name=flox -d -it ghcr.io/flox/flox || \
	 docker run --pull always -v $(cwd):/smdc_portal -v $(cwd)/.flox/build/zshrc:/root/.zshrc -v /var/run/docker.sock:/var/run/docker.sock --name=flox -d -it ghcr.io/flox/flox) || (echo "Container Exists")
	(sudo docker start flox || docker start flox) || (echo "Container is already started...")
	(sudo docker exec -it -w /smdc_portal flox flox activate || docker exec -it -w /smdc_portal flox flox activate)

flox_delete:
	sudo docker rm -f flox || docker rm -f flox

code_server:
ifeq ($(detected_OS),Linux)
	(sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(cwd):$(cwd) --name=code_server -p 443:443 -d matthewhambright/code_server:latest || \
	 docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(cwd):$(cwd) --name=code_server -p 443:443 -d matthewhambright/code_server:latest) || (echo "Container Exists")
endif
ifeq ($(detected_OS),Darwin)
	(sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(cwd):$(cwd) --name=code_server -p 443:443 -d matthewhambright/code_server:latest || \
	 docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(cwd):$(cwd) --name=code_server -p 443:443 -d matthewhambright/code_server:latest) || (echo "Container Exists")
endif
ifeq ($(detected_OS),Windows)
	(docker run -v //var/run/docker.sock:/var/run/docker.sock -v $(cwd):/workspace/smdc_portal --name=code_server -p 443:443 -d matthewhambright/code_server:latest) || (echo "Container Exists")
endif

code_server_use:
	sudo docker exec -it code_server zsh || docker exec -it code_server zsh

code_server_delete:
	sudo docker rm -f code_server || docker rm -f code_server
