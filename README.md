# SMDC Portal ⚡️

SMDC Portal application for keeping track of related sites and tools.

## Project Structure

Built using Qwik, Tauri, and Tailwinds.

## Build App
- Debug
  - If Rust and Bun are installed 
```sh
bun install
bun run build:bun:debug
```
- Release
  - Will Build without any dependancies. However it will install Docker and Dagger
```sh
bun dagger
<!-- or -->
make dagger
<!-- or -->
pwsh .ci/dagger.ps1
<!-- or -->
docker build -t tauri --output type=local,dest=./out/ .
<!-- or -->
make docker
``` 
  - If Rust and Bun are installed 
```sh
bun install
bun run build:bun
```

## Dependancies
### OS Environment
- Arch
    - sudo pacman -S --needed webkit2gtk base-devel curl wget openssl appmenu-gtk-module gtk3 libappindicator-gtk3 librsvg libvips

- Ubuntu
    - sudo apt install libwebkit2gtk-4.0-dev build-essential curl wget libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev -y

- Fedora
    - sudo dnf check-update
    - sudo dnf install webkit2gtk3-devel.x86_64 openssl-devel curl wget libappindicator-gtk3 librsvg2-devel
    - sudo dnf group install "C Development Tools and Libraries"

- MacOS
    - xcode-select --install

- Windows
    - C++ Development Environment from visual studio build tools.(Same one that rust requires)
    - Microsoft Edge Webview Runtime

### Software Environment
- Rust
- Typescript
- Nodejs (NPM)
- Bun
- Git


