FROM alpine:edge

RUN apk upgrade -U --no-cache
RUN apk add -U --no-cache git curl go neovim tmux nodejs yarn sudo gnupg openssh
RUN rm -f /usr/bin/vi && ln -s /usr/bin/nvim /usr/bin/vi

RUN adduser -D -u 1000 ruslan && addgroup ruslan wheel
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopasswd

USER ruslan
WORKDIR /home/ruslan

RUN ssh-keygen -q -f ~/.ssh/id_rsa -t rsa -N ''

RUN mkdir -p ~/.config/nvim/ ~/.local/share/nvim/site/plugins
COPY init.vim .config/nvim/
RUN curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qa &> /dev/null && \
    nvim --headless +GoInstallBinaries +qa &> /dev/null

RUN yarn global -s add prettier &> /dev/null

COPY profile ~/.profile
COPY tmux.conf ~/.tmux.conf
COPY gitconfig ~/.gitconfig

ENV GOPRIVATE="github.com/anhuret"
ENV GONOPROXY="github.com/anhuret"
ENV CGO_ENABLED="0"

CMD ["/bin/ash","-l"]

# podman run --pod devine -itd --userns=keep-id --privileged --name code --network host -v /home/ruslan/code:/home/ruslan/code devine
# podman run --pod devine -d --name postgres --network host -e POSTGRES_PASSWORD=postgres postgres:13-alpine

