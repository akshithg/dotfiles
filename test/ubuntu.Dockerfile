FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    zsh git curl ca-certificates sudo make \
    && rm -rf /var/lib/apt/lists/*

# Add a non-root user with passwordless sudo
RUN useradd -m -s /bin/zsh dev && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

# Copy local repo for testing (avoids GitHub round-trip)
COPY --chown=dev:dev . /tmp/dotfiles-source/
ENV DOTFILES_REPO=/tmp/dotfiles-source

# Run bootstrap
RUN sh /tmp/dotfiles-source/bootstrap.sh

# Install Linux tools
RUN cd /tmp/dotfiles-source && make install-linux

# Verify shell starts cleanly
RUN zsh -i -c 'echo "shell started"; echo "MY_THEME=$MY_THEME"; echo "IS_LINUX=$IS_LINUX"; echo "IS_CONTAINER=$IS_CONTAINER"'

CMD ["zsh"]
