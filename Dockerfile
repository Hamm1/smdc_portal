FROM ubuntu:22.04 AS build_linux
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    pkg-config \
    libssl-dev \
    libgtk-3-dev \
    librsvg2-dev \
    mingw-w64 \
    wine64 \
    unzip \
    python3 \
    gcc \
    g++ \
    make \
    nsis \
    lld \
    llvm \
    clang \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add x86_64-pc-windows-msvc
RUN cargo install --locked cargo-xwin
RUN printf '[target.x86_64-pc-windows-gnu]\nlinker = "x86_64-w64-mingw32-gcc"\nar = "x86_64-w64-mingw32-gcc-ar"\n' > /root/.cargo/config
RUN curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh; rm -f /usr/share/keyrings/nodesource.gpg; chmod 500 nsolid_setup_deb.sh; ./nsolid_setup_deb.sh 23; apt-get install nodejs -y; rm -f ./nsolid_setup_deb.sh
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"
WORKDIR /app
COPY . .
RUN bun install
RUN ["bun", "tauri", "build", "--runner", "cargo-xwin", "--target", "x86_64-pc-windows-msvc"]

FROM scratch as export-stage
COPY --from=build_linux "/app/src-tauri/target/x86_64-pc-windows-msvc/release/smdc_portal.exe" "/"