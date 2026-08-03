# tmux clipboard over SSH

Copying from Claude (running in tmux on a remote host, over ssh, in Terminal.app
on a local Mac) back to the Mac clipboard.

## Conclusion

**Terminal.app does not support OSC 52 clipboard writes.** No tmux setting can
work around this — the sequence reaches Terminal.app and is silently discarded.

The workflow is therefore Terminal.app's own selection: **hold Fn and drag**.
Fn suspends mouse reporting, so the drag makes a native selection instead of
going to tmux, and Cmd+C takes it.

Costs: the selection is the literal screen rectangle. With split panes it grabs
the neighbouring pane's columns too, and wrapped long lines come back with the
wrap points baked in. Fine for short snippets, poor for anything long.

## What the earlier version of this note got wrong

It claimed `set -g set-clipboard on` fixed this, "verified" by having a pane
emit `\033]52;c;<base64>` and observing that a tmux buffer appeared.

That verified the wrong thing. A tmux buffer appearing proves only that **tmux**
accepted the sequence into its own internal state. It says nothing about whether
tmux then forwarded it to the outer terminal, or whether that terminal did
anything with it. The whole chain past tmux went untested, and that is exactly
where it was broken.

`set-clipboard on` is a genuine behaviour change — it just doesn't matter when
the receiving end ignores OSC 52.

## How to actually test this

Isolate the terminal from tmux by writing OSC 52 **straight to the ssh session's
tty**, bypassing tmux entirely:

```sh
tmux display -p '#{client_tty}'          # e.g. /dev/ttys001
printf '\033]52;c;%s\a' "$(printf 'TEST-PAYLOAD' | base64)" > /dev/ttys001
```

Then Cmd+V on the Mac. Try the ST-terminated form too (`\033]52;c;%s\033\\`) —
some terminals accept only one.

Control for the test: write plain visible text to the same tty. If the text
appears in the terminal but the OSC 52 payload never reaches the clipboard, the
terminal is dropping the sequence, and the problem is not tmux.

Verified on tmux 3.6a: both BEL- and ST-terminated forms written direct to the
tty produced nothing on the clipboard, while visible text on the same tty
arrived normally.

## Alternatives, if the Fn+drag rough edges become annoying

- **Different terminal on the Mac.** Ghostty, iTerm2, WezTerm and kitty all do
  OSC 52. The tmux config here already works as-is with any of them, and it
  fixes every ssh host at once, not just the one. iTerm2 needs clipboard access
  enabled (Settings → General → Selection); kitty and Alacritty need it turned
  on in config.
- **`ssh <mac> pbcopy`** from the remote host, wired into tmux's `copy-pipe`.
  Needs the Mac reachable on 22, i.e. Remote Login enabled in System Settings →
  General → Sharing — it is off by default. Use ControlPersist or each copy pays
  a full connection setup.
- **SSH RemoteForward into a pbcopy listener** on the Mac. Avoids needing sshd,
  but wants a launchd agent to keep the listener alive.

## tmux settings, and why they stay

`set-clipboard on` and `allow-passthrough on` are both still set. Neither helps
the clipboard here, but `allow-passthrough on` is wanted anyway so Claude's
progress and notification escapes reach the outer terminal, and `set-clipboard
on` is inert rather than harmful — it becomes the working path immediately if
the terminal is ever switched.

`mouse on` also stays. Turning it off would give back native selection by
default, but costs trackpad scrolling and click-to-focus, and Fn already
suspends it on demand.

Note that a running tmux server does **not** pick up config edits on its own —
`tmux source-file ~/.tmux.conf` (or `C-a r`) is required, and even then
`default-terminal` applies only to newly created panes. A server started before
an edit will quietly keep serving the old values, which is easy to mistake for
the setting not working. This is exactly what had happened here: the config was
correct on disk, the live server still had the defaults.

## Rejected

- `set -as terminal-features ",xterm-256color:clipboard"` — no-op. tmux already
  ships `xterm*:clipboard` by default.
- `tmux -CC` / iTerm2 native integration — would work, but is a terminal switch
  by another name, and the plain OSC 52 route above is simpler if switching.

## Related

`default-terminal` is guarded by `if-shell` rather than hardcoded. Setting it to
a terminfo entry the host lacks does *not* fail loudly — tmux starts and exports
the broken TERM into every pane, breaking vim/less/tput. `tmux-256color` needs
ncurses >= 6, so the config falls back to `screen-256color` on older hosts.
(The host here has it; the live server was showing the fallback only because it
predated the `if-shell`.)
