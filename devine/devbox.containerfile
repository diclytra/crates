FROM registry.fedoraproject.org/fedora

ARG VERS
ARG NAME
ARG UIDN

LABEL name=$NAME
LABEL version=$VERS
LABEL description="Development Environmant"
LABEL maintainer="Nero Dicentra <nero@asgard.id>"

ENV GOPRIVATE="github.com/cetorion"
ENV CGO_ENABLED="0"
ENV GOPATH="/home/$UIDN/.go"
ENV HOSTNAME=$NAME

COPY data/root/nushell.repo /etc/yum.repos.d/nushell.repo
RUN <<-EOF
	echo 'install_weak_deps=False' >> /etc/dnf/dnf.conf
	dnf -y update
	dnf -y install \
	go python pip pipx nodejs yarn shfmt git \
	tmux helix gnupg pinentry-tty nushell gocryptfs \
	python3-pandas python3-numpy python3-llama-cpp-python \
	python3-matplotlib python3-seaborn python3-virtualenv
EOF

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

RUN <<-EOF
	useradd -mU $UIDN
	usermod -aG wheel $UIDN
	mkdir -p /etc/sudoers.d
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopassword
	ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
EOF

USER $UIDN
WORKDIR /home/$UIDN

RUN mkdir -p .ssh && ssh-keygen -t ed25519 -N "" -q -f .ssh/id_ed25519

RUN	yarn global add \
prettier eslint bash-language-server typescript-language-server \
vscode-css-languageservice yaml-language-server

RUN <<-EOF
	go install golang.org/x/tools/gopls@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/nametake/golangci-lint-langserver@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
EOF

RUN <<-EOF
	pipx install python-lsp-server ruff
	pipx inject python-lsp-server python-lsp-ruff
EOF

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -fsSL https://install.julialang.org | sh -s -- -y

RUN nu -c 'mkdir ($nu.data-dir | path join "vendor/autoload")'
RUN nu -c 'starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")'

COPY data/gnupg .gnupg
COPY data/helix .config/helix
COPY data/home/tmux.conf .tmux.conf
COPY data/home/gitconfig .gitconfig
COPY data/nushell/config.nu .config/nushell/config.nu
COPY data/ssh .ssh

USER root
RUN chmod 700 .gnupg
RUN chown -R $UIDN:$UIDN /home/$UIDN
RUN usermod -s /usr/bin/nu $UIDN
RUN usermod -s /usr/bin/nu root

USER $UIDN

ENTRYPOINT ["/usr/bin/nu", "-i", "-l"]
