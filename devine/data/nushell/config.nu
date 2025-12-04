let trail = [~/.local/bin ~/.cargo/bin ~/.juliaup/bin ~/.yarn/bin ~/.go/bin]
$env.path = ($env.path | prepend $trail | uniq)

$env.NU_LIB_DIRS = ["~/nu"]
$env.config.datetime_format.normal = "%y/%m/%d %I:%M:%S%p"
$env.config.table.index_mode = "auto"
$env.config.buffer_editor = 'hx'
$env.config.show_banner = false
$env.config.table.mode = "light"

gpgconf --kill all o> /dev/null
gpgconf --launch gpg-agent o> /dev/null
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)
$env.GPG_TTY = (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

if (is-terminal -i) {
  if ($env.tmux? | is-empty) {
    tmux -2u new -A -s main
  }
}
