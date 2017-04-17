SESSION_TYPE="local"

# Source: unix.stackexchange.com/a/9607
# Detect ssh session
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="remote/ssh"
# many other tests omitted
else
  case $(ps -o comm= -p $PPID) in
      sshd|*/sshd) SESSION_TYPE="remote/ssh";;
  esac
fi
