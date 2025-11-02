
set shell := ["bash", "-uc"]
set windows-shell := ["pwsh.exe","-c"]
sudo := if os_family() == "windows" { "" } else { "sudo" }

test:
	cargo test --manifest-path src-tauri/Cargo.toml

run:
	bun run dev

start:
	bun run start

install:
	bun install || npm install

qwik:
	bun install && bun qwik:build

build:
	(bun install && bun run build:bun:debug) || (npm install -force && npm run build:npm:debug)

release:
	bun run build:bun || npm run build

debug:
	bun run build:bun:debug || npm run build:npm:debug

fmt:
	bun run fmt

clean:
	bun run clean || npm run clean

upgrade:
	bun update || npx npm-check-updates -u

docker:
	{{ sudo }} docker build -t tauri --output type=local,dest=./out/ .

dagger := if os_family() == "windows" { "pwsh dagger.ps1" } else { "dagger.sh" }
dagger:
	cd .ci && {{ dagger }}

dagger_windows := if os_family() == "windows" { 
		"Start-Process 'dagger' -ArgumentList 'call windows --src=../ export --path=" + invocation_directory() + "/out/smdc_portal.exe' -Wait -NoNewWindow"
	} else { 
		"dagger call windows --src=../ export --path=" + invocation_directory() + "/out/smdc_portal.exe"
	}
dagger_windows:
	cd .ci && {{ dagger_windows }}

dagger_linux := if os_family() == "windows" { 
		"Start-Process 'dagger' -ArgumentList 'call linux --src=../ export --path=" + invocation_directory() + "/out/smdc_portal' -Wait -NoNewWindow"
	} else { 
		"dagger call linux --src=../ export --path=" + invocation_directory() + "/out/smdc_portal"
	}
dagger_linux:
	cd .ci && {{ dagger_linux }}

flox:
	({{ sudo }} docker run --pull always -v {{invocation_directory()}}:/smdc_portal -v {{invocation_directory()}}/.flox/build/zshrc:/root/.zshrc -v /var/run/docker.sock:/var/run/docker.sock --name=flox -d -it ghcr.io/flox/flox) || (echo "Container Exists")
	({{ sudo }} docker start flox) || (echo "Container is already started...")
	@{{ sudo }} docker exec -it -w /smdc_portal flox flox activate

flox_delete:
	{{ sudo }} docker rm -f flox

workspace := if os_family() == "windows" { "{{invocation_directory()}}" } else { "/workspace/smdc_portal" }
code_server:
	({{ sudo }} docker run -v /var/run/docker.sock:/var/run/docker.sock -v {{invocation_directory()}}:{{ workspace }} --name=code_server -p 443:443 -d matthewhambright/code_server:latest) || (echo "Container Exists")

code_server_use:
	{{ sudo }} docker exec -it code_server zsh

code_server_delete:
	{{ sudo }} docker rm -f code_server