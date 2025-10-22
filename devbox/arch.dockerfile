FROM archlinux

ENV GOPRIVATE="github.com/anhuret,gitlab.com/onuris"
ENV CGO_ENABLED="0"

ARG VERS="0.1"
ARG NAME
ARG UIDN

LABEL name=$NAME
LABEL version=$VERS
LABEL description="Development Environmant"
LABEL maintainer="Nero Dicentra <nero@asgard.id>"

RUN <<-'EOF'
	pacman --noconfirm -Syu
	pacman --noconfirm -S \
	fish sudo less openssh git tmux go nodejs yarn helix vivid shfmt python
	pacman --noconfirm -Scc
EOF

RUN ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

RUN <<-'EOF'
	useradd -m $UIDN && usermod -a -G wheel $UIDN
	mkdir -p /etc/sudoers.d
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopass
EOF

USER $UIDN
WORKDIR /home/$UIDN

RUN yarn global add \
	prettier eslint bash-language-server typescript-language-server \
	vscode-css-languageservice vscode-css-languageservice yaml-language-server

RUN <<-'EOF'
	go install golang.org/x/tools/gopls@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/nametake/golangci-lint-langserver@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
EOF

COPY files/fish .config/fish
COPY files/helix .config/helix
COPY files/gnupg .gnupg
COPY files/home/gitconfig .gitconfig
COPY files/home/tmux.conf .tmux.conf

USER root
RUN chmod 700 .gnupg
RUN chown -R $UIDN:$UIDN /home/$UIDN
USER $UIDN

CMD ["tmux", "-2", "new", "-s", "main"]
