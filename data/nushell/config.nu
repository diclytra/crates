let trail = [
  'code/bin'
  '.local/bin'  
  '.deno/bin'
  '.cargo/bin'
  '.juliaup/bin'
  '.yarn/bin'
  '.go/bin'
]
let trail = ['code/bin' '.local/bin' '.cargo/bin' '.juliaup/bin' '.yarn/bin' '.go/bin']
let path = $trail | each {|t| $env.home | path join $t}
$env.path = ($env.path | prepend $path | uniq)

$env.nu_lib_dirs = [($env.home | path join 'code/nu')]
$env.config.datetime_format.normal = "%y/%m/%d %I:%M:%S%p"
$env.config.table.index_mode = 'auto'
$env.config.buffer_editor = 'hx'
$env.config.show_banner = false
$env.config.table.mode = 'light'

gpgconf --kill all o> /dev/null
gpgconf --launch gpg-agent o> /dev/null
$env.ssh_auth_sock = (gpgconf --list-dirs agent-ssh-socket)
$env.gpg_tty = (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

if (is-terminal -i) {
  if ($env.tmux? | is-empty) {
    tmux -2u new -A -s main
  }
}
