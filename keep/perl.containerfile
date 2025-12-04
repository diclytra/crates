FROM registry.fedoraproject.org/fedora

ARG VERS
ARG NAME
ARG UIDN

LABEL name=$NAME
LABEL version=$VERS
LABEL description="Perl Environmant"
LABEL maintainer="Nero Dicentra <nero@asgard.id>"

ENV HOSTNAME=$NAME

RUN <<-EOF
	echo 'install_weak_deps=False' >> /etc/dnf/dnf.conf
	dnf -y update
	dnf -y install \
	fish python pip pipx git helix gnupg pinentry-tty gocryptfs
EOF

RUN <<-EOF
	useradd -mU $UIDN
	usermod -aG wheel $UIDN
	mkdir -p /etc/sudoers.d
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nopassword
	mkdir -p /data/host
	chown -R $UIDN:$UIDN /data/host
	ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
EOF

USER $UIDN
WORKDIR /home/$UIDN

RUN mkdir -p .ssh && ssh-keygen -t ed25519 -N "" -q -f .ssh/id_ed25519
COPY files/home/ssh_config .ssh/config

RUN <<-EOF
	pipx install python-lsp-server ruff
	pipx inject python-lsp-server python-lsp-ruff
EOF

RUN <<-EOF
	fish -c "yes | fish_config theme save Tomorrow"
	fish -c "yes | fish_config prompt save minimalist"
	fish -c "set -U fish_greeting"
	fish -c "fish_add_path -U /home/${UIDN}/.local/bin /home/${UIDN}/.yarn/bin /home/${UIDN}/.go/bin"
EOF

COPY files/fish .config/fish
COPY files/gnupg .gnupg
COPY files/helix .config/helix
COPY files/home/profile .profile
COPY files/home/gitconfig .gitconfig

USER root
RUN chmod 700 .gnupg
RUN chown -R $UIDN:$UIDN /home/$UIDN
USER $UIDN

ENTRYPOINT ["/usr/bin/fish"]
CMD ["-l", "-i"]
