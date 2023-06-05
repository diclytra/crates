set  fish_greeting
fish_vi_key_bindings

alias vi="/usr/bin/nvim"

function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s: [%s] > ' (hostname) (prompt_pwd)
  set_color normal

end

