#devbox
eval "$(devbox global shellenv --init-hook)"

# 1Password SSH agent setup
case "$(uname -a)" in
*microsoft* | *Microsoft*)
  # WSL-specific configuration
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
    if test -x "$wsl2_ssh_pageant_bin"; then
      (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
    fi
  fi
  ;;
*Darwin*)
  # macOS configuration
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
  ;;
*)
  # Linux configuration
  export SSH_AUTH_SOCK=~/.1password/agent.sock
  ;;
esac

