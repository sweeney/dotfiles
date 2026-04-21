s() {
  case "$1" in
    --help|-h)
      echo "screen shortcuts:"
      echo "  sn <name>   start a new named screen session"
      echo "  sl          list running screen sessions"
      echo "  sr [name]   reattach to a session (auto-picks if only one running)"
      echo "  sd          detach from current screen session"
      echo "  isscreen    show whether you're inside a screen session"
      echo "  realexit    actually exit when inside a screen session"
      echo ""
      echo "inside screen:"
      echo "  Ctrl-a d    detach (keeps session running)"
      echo "  Ctrl-a c    new window"
      echo "  Ctrl-a n/p  next/prev window"
      echo "  Ctrl-a \"    list windows"
      echo "  exit        close current window"
      echo ""
      echo "tip: always Ctrl-a d before you exit SSH"
      ;;
    *)
      echo "Usage: s --help"
      ;;
  esac
}

isscreen() {
  if [ -n "$STY" ]; then
    echo "yes — session: $STY, window: $WINDOW"
    return 0
  else
    echo "no"
    return 1
  fi
}

exit() {
  if [ -n "$STY" ]; then
    echo "You're inside a screen session ($STY)."
    echo "Detach with Ctrl-a d, or type 'realexit' to exit anyway."
    return 1
  fi
  builtin exit "$@"
}

realexit() { builtin exit "$@"; }

sn() { screen -S "${1:?Usage: sn <name>}"; }
sl() { screen -ls; }
sd() { screen -d "$STY"; }

sr() {
  if [ -n "$1" ]; then
    TERM=xterm screen -Dr "$1"
    return
  fi

  local sessions
  sessions=$(screen -ls | grep -E '^\s+[0-9]+\.')
  local count
  count=$(echo "$sessions" | grep -c '[0-9]')

  if [ "$count" -eq 1 ]; then
    local name
    name=$(echo "$sessions" | awk '{print $1}')
    TERM=xterm screen -Dr "$name"
  elif [ "$count" -eq 0 ]; then
    echo "No screen sessions running"
  else
    echo "Multiple sessions — specify one:"
    screen -ls
  fi
}
