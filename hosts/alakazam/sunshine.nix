{ config, pkgs, ... }:

let
  setRes = pkgs.writeShellScript "sunshine-set-res" ''
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

    MONITOR=$(${pkgs.gnome-randr}/bin/gnome-randr | ${pkgs.gnugrep}/bin/grep -E "^(DP|HDMI|eDP)-[0-9]" | head -n 1 | ${pkgs.gawk}/bin/awk '{print $1}')

    if [ -z "$MONITOR" ]; then
      MONITOR="DP-2"
    fi

    echo "[$(date)] Setting resolution on $MONITOR to 1280x800" >> /run/user/1000/sunshine.log

    ${pkgs.gnome-randr}/bin/gnome-randr modify "$MONITOR" --mode 1280x800@59.910 >> /run/user/1000/sunshine.log 2>&1
    ERR=$?

    if [ $ERR -eq 0 ]; then
      echo "[$(date)] Resolution change succeeded" >> /run/user/1000/sunshine.log
    else
      echo "[$(date)] Resolution change FAILED (exit code $ERR)" >> /run/user/1000/sunshine.log
      exit 1
    fi

    sleep 2
  '';

  restoreRes = pkgs.writeShellScript "sunshine-restore-res" ''
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

    MONITOR=$(${pkgs.gnome-randr}/bin/gnome-randr | ${pkgs.gnugrep}/bin/grep -E "^(DP|HDMI|eDP)-[0-9]" | head -n 1 | ${pkgs.gawk}/bin/awk '{print $1}')
    if [ -z "$MONITOR" ]; then
      MONITOR="DP-2"
    fi

    echo "[$(date)] Killing steam" >> /run/user/1000/sunshine.log
    pkill -9 steam 2>/dev/null || true
    echo "[$(date)] Restoring resolution on $MONITOR to 3440x1440" >> /run/user/1000/sunshine.log
    ${pkgs.gnome-randr}/bin/gnome-randr modify "$MONITOR" --mode 3440x1440@59.973 >> /run/user/1000/sunshine.log 2>&1
    echo "[$(date)] Session ended" >> /run/user/1000/sunshine.log
  '';

  startSteam = pkgs.writeShellScript "sunshine-start-steam" ''
    echo "[$(date)] Starting Steam session (DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY)" >> /run/user/1000/sunshine.log

    pkill -9 steam 2>/dev/null || true
    sleep 1

    systemd-run --user --collect \
      --property=StandardOutput=append:/run/user/1000/sunshine.log \
      --property=StandardError=append:/run/user/1000/sunshine.log \
      --setenv=WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
      --setenv=DISPLAY="$DISPLAY" \
      --setenv=XDG_RUNTIME_DIR="/run/user/1000" \
      --setenv=DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" \
      /run/current-system/sw/bin/steam -gamepadui

    sleep 15

    echo "[$(date)] Steam launched, watching process" >> /run/user/1000/sunshine.log
    while ${pkgs.procps}/bin/pgrep -i steam > /dev/null; do
      sleep 3
    done
    echo "[$(date)] Steam exited, ending session" >> /run/user/1000/sunshine.log
  '';
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      env.PATH = "$(PATH):$(HOME)/.local/bin:/run/current-system/sw/bin";
      apps = [
        {
          name = "Steam Deck";
          auto-detach = "false";
          exclusive = "true";
          prep-cmd = [
            {
              do = "${setRes}";
              undo = "${restoreRes}";
            }
          ];
          cmd = "${startSteam}";
        }
      ];
    };
  };

  environment.shellAliases = {
    sun-on = "systemctl --user start sunshine";
    sun-off = "systemctl --user stop sunshine";
    sun-check = "systemctl --user status sunshine";
    sun-log = "journalctl --user -u sunshine -f";
    sun-web = "firefox https://localhost:47990";
    sun-game = "tail -f /run/user/1000/sunshine.log";
  };
}
