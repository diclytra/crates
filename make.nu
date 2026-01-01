const cfg_path = (path self config.toml)
const stp_path = (path self stamp.toml)

def main [--build(-b) --run(-r) --clean(-c)] {
  let cfg = (open $cfg_path)
  
  if $build {
    build $cfg
  }

  if $run {
    run $cfg
  }

  if $clean {
    clean $cfg
  }
}

def build [cfg: record] {
  let file = $"($cfg.name).containerfile"
  let tag = (date now | format date "%y%m%d%H%M%S")

	let args = [
    build
    --build-arg
    $'NAME=($cfg.name)'
    --build-arg
    $'UIDN=($cfg.uidn)'
    -t
    $'($cfg.name):($tag)'
    -f
    $file
  ]
  
  ^($cfg.cli) ...$args
	^($cfg.cli) tag $'($cfg.name):($tag)' $'($cfg.name):latest'
}

def run [cfg: record] {
  let base = [/home $cfg.uidn]
  let name = $'($cfg.name)-(random int 10..99)'
  let vls = $cfg.volume | items {|k, v|
    [-v $'($v):($base | path join $k)']
  } | flatten
  
	let args = [
		run
    -itd
		--privileged
		--userns=keep-id
		-u
    $cfg.uidn
		--name
    $name
		--hostname
    $cfg.name
		-p
    1234:1234
		-p
    8000:8000
		...$vls
		$'localhost/($cfg.name):latest'
	]

  ^($cfg.cli) ...$args
}

def clean [cfg: record] {
	^($cfg.cli) ...[container prune -f]
	^($cfg.cli) ...[image prune -af]
}
