
set shell := ["bash", "-uc"]
set windows-shell := ["pwsh.exe","-c"]
sudo := if os_family() == "windows" { "" } else { "sudo" }
bun := if os() == "windows" {
    `pwsh -c 'where.exe bun || echo Unknown'`
} else {
    `sh -c 'which bun 2>/dev/null || echo Unknown'`
}
npm := if os() == "windows" {
    `pwsh -c 'where.exe npm || echo Unknown'`
} else {
    `sh -c 'which npm 2>/dev/null || echo Unknown'`
}
pkg_manager := if bun != "Unknown" { bun } else { npm }

test:
	cargo test --manifest-path src-tauri/Cargo.toml

run:
	{{ pkg_manager }} run dev

start:
	{{ pkg_manager }} run start

install:
	{{ pkg_manager }} install

qwik:
	{{ pkg_manager }} install && {{ pkg_manager }} qwik:build

build:
	({{ pkg_manager }} install && {{ pkg_manager }} run build:{{ pkg_manager }}:debug)

release:
	{{ pkg_manager }} run build:bun

debug:
	{{ pkg_manager }} run build:bun:debug

fmt:
	{{ pkg_manager }} run fmt

clean:
	{{ pkg_manager }} run clean

upgrade:
	{{ pkg_manager }} update || npx npm-check-updates -u

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