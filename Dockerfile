FROM alpine:edge

RUN apk add --no-cache -U git curl go neovim tmux nodejs yarn sudo make gcc g++ python3

RUN adduser -D -u 1000 ruslan && addgroup ruslan wheel
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopasswd

USER ruslan
WORKDIR /home/ruslan

RUN mkdir -p ~/.config/nvim/ ~/.local/share/nvim/site/plugins
COPY init.vim .config/nvim/
RUN curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qa &> /dev/null && \
    nvim --headless +GoInstallBinaries +qa &> /dev/null

RUN yarn global -s add node-gyp &> /dev/null && \
    yarn global -s add parcel prettier sass typescript &> /dev/null

RUN echo 'export PATH="$(yarn global bin):~/go/bin:$PATH"' > ~/.profile && \
    echo '[ -z $TMUX  ] && { tmux attach || exec tmux -2 new;}' >> ~/.profile

EXPOSE 1234

CMD ["/bin/ash","-l"]

