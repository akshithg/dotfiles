FROM archlinux:latest

RUN pacman -Sy --noconfirm --needed \
    zsh git curl base-devel sudo \
    && pacman -Scc --noconfirm

RUN useradd -m -s /bin/zsh dev && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

COPY --chown=dev:dev . /tmp/dotfiles-source/
ENV DOTFILES_REPO=/tmp/dotfiles-source

RUN sh /tmp/dotfiles-source/bootstrap.sh
RUN cd /tmp/dotfiles-source && make install-linux

RUN zsh -i -c 'echo "shell started"; echo "MY_THEME=$MY_THEME"; echo "IS_LINUX=$IS_LINUX"; echo "IS_CONTAINER=$IS_CONTAINER"'

CMD ["zsh"]
