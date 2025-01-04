import { dag, Directory, object, func, File } from "@dagger.io/dagger"

@object()
export class Ci {

  @func()
  windows(src: Directory): File {
    return dag
      .container()
      .from("ubuntu:22.04")
      .withEnvVariable("DEBIAN_FRONTEND", "noninteractive")
      .withExec(["apt-get", "update"])
      .withExec(["apt-get", "install", "-y", "curl", "wget", "git", "pkg-config",
                  "libssl-dev", "libgtk-3-dev", "librsvg2-dev","mingw-w64",
                  "wine64","unzip","python3","gcc","g++","make",
                  "nsis","lld","llvm","clang","build-essential"])
      .withExec(["curl", "--proto", "=https", "--tlsv1.2", "-sSf","https://sh.rustup.rs", "-o", "rustup-init.sh"])
      .withExec(["chmod", "+x", "rustup-init.sh"])
      .withExec(["./rustup-init.sh", "-y", "--no-modify-path"])
      .withEnvVariable("PATH", "/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
      .withExec(["rustup", "target", "add", "x86_64-pc-windows-msvc"])
      .withExec(["cargo","install","--locked","cargo-xwin"])
      .withExec(["sh", "-c", 'echo "[target.x86_64-pc-windows-gnu]\nlinker = \"x86_64-w64-mingw32-gcc\"\nar = \"x86_64-w64-mingw32-gcc-ar\"" > /root/.cargo/config'])
      .withExec(["curl","-SLO","https://deb.nodesource.com/nsolid_setup_deb.sh"])
      .withExec(["rm","-f","/usr/share/keyrings/nodesource.gpg"])
      .withExec(["chmod","500","nsolid_setup_deb.sh"])
      .withExec(["./nsolid_setup_deb.sh","23"])
      .withExec(["apt-get","install","nodejs","-y"])
      .withExec(["curl", "-fsSL", "https://bun.sh/install", "-o", "bun-installer.sh"])
      .withExec(["chmod", "+x", "bun-installer.sh"])
      .withExec(["./bun-installer.sh"])
      .withEnvVariable("PATH", "/root/.bun/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
      .withMountedDirectory("/app", src)
      .withWorkdir("/app")
      .withExec(["pwd"])
      .withExec(["ls", "-la"])
      .withExec(["ls", "-la", "src-tauri"])
      .withExec(["test", "-f", "src-tauri/Cargo.toml"])
      .withExec(["find", ".", "-name", "Cargo.toml"])
      .withExec(["bun", "install"])
      .withExec(["bun", "add", "-d", "@tauri-apps/cli"])
      .withExec(["bun", "tauri", "build", "--runner", "cargo-xwin", "--target", "x86_64-pc-windows-msvc"])
      .file("/app/src-tauri/target/x86_64-pc-windows-msvc/release/smdc_portal.exe")
  }
}
