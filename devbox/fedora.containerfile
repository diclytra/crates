FROM registry.fedoraproject.org/fedora

ENV GOPRIVATE="github.com/anhuret,gitlab.com/onuris"
ENV CGO_ENABLED="0"
ENV HOSTNAME=$NAME

ARG VERS
ARG NAME
ARG UIDN

LABEL name=$NAME
LABEL version=$VERS
LABEL description="Development Environmant"
LABEL maintainer="Nero Dicentra <tensor@eridium.one>"

RUN <<-'EOF'
	echo "install_weak_deps=False" >> /etc/dnf/dnf.conf
	dnf -y update
	dnf -y install \
	fish go git tmux nodejs yarn helix shfmt gnupg pinentry-tty golangci-lint
EOF

RUN <<-'EOF'
	useradd -mU $UIDN
	usermod -aG wheel $UIDN
	mkdir -p /etc/sudoers.d
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopassword
	mkdir -p /data
	chown -R $UIDN:$UIDN /data
	ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
EOF

USER $UIDN
WORKDIR /home/$UIDN

RUN mkdir -p .ssh && ssh-keygen -t ed25519 -N "" -q -f .ssh/id_ed25519
COPY files/home/ssh_config .ssh/ssh_config

RUN	yarn global add \
prettier eslint bash-language-server typescript-language-server \
vscode-css-languageservice yaml-language-server

RUN <<-'EOF'
	go install golang.org/x/tools/gopls@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/nametake/golangci-lint-langserver@latest
	#go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
EOF

COPY files/fish .config/fish
COPY files/gnupg .gnupg
COPY files/helix .config/helix
COPY files/home/profile .profile
COPY files/home/eslintrc .eslintrc
COPY files/home/tmux.conf .tmux.conf
COPY files/home/gitconfig .gitconfig

USER root
RUN chmod 700 .gnupg
RUN chown -R $UIDN:$UIDN /home/$UIDN
USER $UIDN

CMD ["tmux", "-2", "new", "-s", "main"]
