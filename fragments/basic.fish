function fish_prompt
  set_color -o green
  echo -n [ (prompt_pwd) ]
  echo -n ' ~> '
  set_color normal
end

function fish_greeting
  echo (date)
end

