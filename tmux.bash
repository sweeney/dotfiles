t() {
  case "$1" in
    --help|-h)
      echo "tmux shortcuts:"
      echo "  tn <name>   start a new named tmux session"
      echo "  tl          list running tmux sessions"
      echo "  ta [name]   attach to a session (auto-picks if only one running)"
      echo "  td          detach from current tmux session"
      echo "  istmux      show whether you're inside a tmux session"
      echo "  realexit    actually exit when inside a tmux session"
      echo ""
      echo "inside tmux (prefix is Ctrl-a):"
      echo "  Ctrl-a d    detach (keeps session running)"
      echo "  Ctrl-a c    new window"
      echo "  Ctrl-a n/p  next/prev window"
      echo "  Ctrl-a w    list windows (interactive)"
      echo "  Ctrl-a ,    rename current window"
      echo "  Ctrl-a |    split pane vertical"
      echo "  Ctrl-a -    split pane horizontal"
      echo "  Ctrl-a hjkl move between panes"
      echo "  Ctrl-a z    zoom current pane (toggle)"
      echo "  Ctrl-a x    kill pane"
      echo "  Ctrl-a [    copy mode (scroll); q to exit"
      echo "  Ctrl-a r    reload config"
      echo "  exit        close current pane/window"
      echo ""
      echo "tip: always Ctrl-a d before you exit SSH"
      ;;
    *)
      echo "Usage: t --help"
      ;;
  esac
}

istmux() {
  if [ -n "$TMUX" ]; then
    echo "yes — session: $(tmux display-message -p '#S'), window: $(tmux display-message -p '#I')"
    return 0
  else
    echo "no"
    return 1
  fi
}

tn() { tmux new -s "${1:?Usage: tn <name>}"; }
tl() { tmux ls; }
td() { tmux detach; }

ta() {
  if [ -n "$1" ]; then
    tmux attach -d -t "$1"
    return
  fi

  local count
  count=$(tmux ls 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" -eq 1 ]; then
    local name
    name=$(tmux ls | head -n1 | cut -d: -f1)
    tmux attach -d -t "$name"
  elif [ "$count" -eq 0 ]; then
    echo "No tmux sessions running"
  else
    echo "Multiple sessions — specify one:"
    tmux ls
  fi
}
