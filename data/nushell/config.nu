let trail = [
 '.local'  
 '.deno'
 '.cargo'
 '.juliaup'
 '.yarn'
 '.go'
] | each {|e| $env.home | path join $e bin} | append $env.path | uniq

let nude = [
 'nuts'
 ] | each {|e| $env.home | path join $e}

$env.path = $trail
$env.nu_lib_dirs = $nude
$env.config.datetime_format.normal = "%y/%m/%d %I:%M:%S%p"
$env.config.table.index_mode = 'auto'
$env.config.buffer_editor = 'hx'
$env.config.edit_mode = 'vi'
$env.config.show_banner = false
$env.config.table.mode = 'light'

gpgconf --kill all | ignore
gpgconf --launch gpg-agent | ignore
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)
$env.GPG_TTY = (tty)
gpg-connect-agent updatestartuptty /bye | ignore
  
if (is-terminal -i) {
 if ($env.tmux? | is-empty) {
  tmux -2u new -A -s zero; exit
 }
}

let carapace_completer = {|spans: list<string>|
 carapace $spans.0 nushell ...$spans
 | from json
 | if ($in | default [] | any {|| $in.display | str starts-with "ERR"}) { null } else { $in }
}

$env.config.completions.external = {
 enable: true
 max_results: 100
 completer: $carapace_completer
}
