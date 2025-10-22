FROM docker.io/library/alpine:edge

ENV GOPRIVATE="github.com/anhuret,gitlab.com/onuris"
ENV CGO_ENABLED="0"

ARG VERS
ARG NAME
ARG UIDN

LABEL name=$NAME
LABEL version=$VERS
LABEL description="GO and JS development environmant"
LABEL maintainer="Nero Dicentra <nero.dicentra@gmail.com>"

RUN apk upgrade -U --no-cache
RUN apk add --no-cache \
go git curl neovim tmux nodejs yarn sudo helix tree-sitter-grammars \
openssh-client gpg gpg-agent pinentry-tty tzdata

RUN ln -sf /usr/bin/nvim /usr/bin/nv
RUN ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

RUN adduser -D $UIDN && addgroup $UIDN wheel
RUN mkdir -p /etc/sudoers.d && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopasswd
RUN echo $NAME > /etc/hostname
RUN mkdir -p /data && chown -R $UIDN:$UIDN /data

USER $UIDN
WORKDIR /home/$UIDN

RUN mkdir -p ~/code ~/.config/nvim/ ~/.local/share/nvim/site/plugins
COPY files/nvim/init.vim .config/nvim/

RUN curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qa &> /dev/null && \
    nvim --headless +GoInstallBinaries +qa &> /dev/null
RUN yarn global add prettier eslint

COPY files/home/profile .profile
COPY files/home/tmux.conf .tmux.conf
COPY files/home/gitconfig .gitconfig
COPY files/home/eslintrc .eslintrc
COPY files/gnupg .gnupg
COPY files/helix .config/helix

USER root
RUN chown -R $UIDN:$UIDN /home
USER $UIDN

CMD ["/bin/ash","-l"]
