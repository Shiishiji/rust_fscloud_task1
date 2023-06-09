# syntax = docker/dockerfile:1.5.2
FROM --platform=$BUILDPLATFORM rust:1.69 as builder

ARG TARGETPLATFORM
RUN case "$TARGETPLATFORM" in \
  "linux/arm/v7")  \
    echo armv7-unknown-linux-gnu > /rust_target.txt ;; \
  "linux/arm64") \
    echo aarch64-unknown-linux-gnu > /rust_target.txt ;; \
  "linux/amd64") \
    echo x86_64-unknown-linux-gnu > /rust_target.txt ;; \
  *) echo $TARGETPLATFORM ; exit 1 ;; \
esac

RUN rustup target add $(cat /rust_target.txt)

WORKDIR /app/src/
RUN apt-get update && \
    apt-get install -yq \
        musl-tools \
        libssl-dev \
        pkgconf \
        libudev-dev \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    USER=root cargo new rust_fscloud_task1 --bin

# Build dummy app
WORKDIR /app/src/rust_fscloud_task1
COPY --link Cargo.lock Cargo.toml ./
RUN cargo build --release --target $(cat /rust_target.txt)

# Build actual app
COPY --link src ./src
RUN cargo install --target $(cat /rust_target.txt) --path .

RUN mv /app/src/rust_fscloud_task1/target/$(cat /rust_target.txt)/* /app/src/rust_fscloud_task1/target


FROM debian:stable-slim

WORKDIR /app
EXPOSE 8080

COPY --from=builder /app/src/rust_fscloud_task1/target/release/rust_fscloud_task1 ./

# Labels.
LABEL author="Damian Szopiński"
LABEL maintainer="shiishiji.dev@gmail.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="siguard/rust_fscloud_task1:main"
LABEL org.label-schema.description="Pollub task 1 for cloud laboratory"
LABEL org.label-schema.vcs-url="https://github.com/Shiishiji/rust_fscloud_task1"
LABEL org.label-schema.docker.cmd="docker run -p 8080:8080 -v ./var:/app/var --rm -it rust_fscloud_task1:main"

CMD [ "/app/rust_fscloud_task1" ]