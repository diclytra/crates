FROM docker.io/library/alpine:edge

ENV GOPRIVATE="github.com/anhuret,gitlab.com/onuris"
ENV CGO_ENABLED="0"

ARG VERS
ARG NAME
ARG UIDN

LABEL name=$NAME
LABEL version=$VERS
LABEL description="Development Environmant"
LABEL maintainer="Nero Dicentra <tensor@eridium.one>"

RUN <<-'EOF'
	apk upgrade -U --no-cache
	apk add --no-cache \
	fish go git curl neovim tmux nodejs yarn sudo helix tree-sitter-grammars \
	vivid shfmt python3 openssh-client gpg gpg-agent pinentry-tty tzdata
EOF

RUN ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

RUN <<-'EOF'
	adduser -D $UIDN && addgroup $UIDN wheel
	mkdir -p /etc/sudoers.d && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopasswd
	echo $NAME > /etc/hostname
	mkdir -p /data && chown -R $UIDN:$UIDN /data
EOF

USER $UIDN
WORKDIR /home/$UIDN

COPY files/fish .config/fish
COPY files/gnupg .gnupg
COPY files/helix .config/helix
COPY files/nvim/init.vim .config/nvim/
COPY files/home/profile .profile
COPY files/home/bashrc .bashrc
COPY files/home/eslintrc .eslintrc
COPY files/home/gitconfig .gitconfig
COPY files/home/tmux.conf .tmux.conf

RUN <<-'EOF'
	yarn global add \
	prettier eslint bash-language-server typescript-language-server \
	vscode-css-languageservice vscode-css-languageservice yaml-language-server
	mkdir -p ~/.local/share/nvim/site/plugins
	curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim --headless +PlugInstall +qa &> /dev/null
	nvim --headless +GoInstallBinaries +qa &> /dev/null
EOF

RUN <<-'EOF'
	go install golang.org/x/tools/gopls@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/nametake/golangci-lint-langserver@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
EOF

USER root
RUN chmod 700 .gnupg
RUN chown -R $UIDN:$UIDN /home/$UIDN
USER $UIDN

CMD ["tmux", "-2", "new", "-s", "main"]
