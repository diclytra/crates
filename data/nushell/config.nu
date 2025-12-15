let trail = [
  'devine/code'
  '.local/bin'  
  '.deno/bin'
  '.cargo/bin'
  '.juliaup/bin'
  '.yarn/bin'
  '.go/bin'
]
let path = $trail | each {|t| $env.home | path join $t}
$env.path = ($env.path | prepend $path | uniq)

$env.nu_lib_dirs = [($env.home | path join 'devine/nu')]
$env.config.datetime_format.normal = "%y/%m/%d %I:%M:%S%p"
$env.config.table.index_mode = 'auto'
$env.config.buffer_editor = 'hx'
$env.config.show_banner = false
$env.config.table.mode = 'light'

gpgconf --kill all | ignore
gpgconf --launch gpg-agent | ignore
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)
$env.GPG_TTY = (tty)
gpg-connect-agent updatestartuptty /bye | ignore

if (is-terminal -i) {
  if ($env.tmux? | is-empty) {
    tmux -2u new -A -s main; exit
  }
}
