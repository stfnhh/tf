#!/usr/bin/env bash

url="https://raw.githubusercontent.com/stfnhh/tf/master/tf.sh"
path="/usr/local/bin/tf"

if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi

abort() {
  printf "%s\n" "$1"
  exit 1
}

tty_underline="$(tty_escape "4;39")"
tty_reset="$(tty_escape 0)"


if ! command -v aws >/dev/null; then
    abort "$(cat <<EOABORT
You must install the aws cli before installing tf. See:
  ${tty_underline}https://aws.amazon.com/cli/${tty_reset}
EOABORT
)"
fi

curl $url > $path
chmod +x $path