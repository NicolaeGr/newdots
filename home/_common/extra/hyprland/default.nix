{
  inputs,
  hostName,
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    ./hyprlock
    ./hypridle
    ./waybar
    ./rofi
    ./swww
  ];

  options = {
    extra.hyprland.enable = lib.mkEnableOption {
      default = true;
      description = "Enable Hyprland compositor";
    };
  };

  config = lib.mkIf config.extra.hyprland.enable {
    extra.hyprland.hypridle.enable = true;
    extra.hyprland.hyprlock.enable = true;
    extra.hyprland.rofi.enable = true;
    extra.hyprland.swww.enable = true;
    extra.hyprland.waybar.enable = true;

    home.packages = [ inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default ];

    services.flatpak.packages = [ "app.zen_browser.zen" ];

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enable = true;
        variables = [ "--all" ];
        extraCommands = lib.mkBefore [
          ''export SSH_AUTH_SOCK="${config.home.homeDirectory}/.local/share/keyrings/ssh"''
          ''export XDG_CURRENT_DESKTOP="Hyprland"''

          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };

      settings = {
        exec-once = [ ];

        monitor =
          if (hostName == "odin") then
            [
              "eDP-1,highres,100x0,1"
              # "HDMI-A-1,2560x1440@59.95,0x0,1"
            ]
          else if (hostName == "axilon") then
            [
              "eDP-1,highres,365x1440,1"
              "HDMI-A-1,2560x1440@59.95,0x0,1"
              "DP-1,1920x1080@60.00000,2285x1440,1"
            ]
          else
            [ "eDP-1,highres,100x0,1" ];

        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$menu" = "rofi -show drun";
        "$fileManager" = "nautilus";

        #
        # ========== Behavior ==========
        #
        env = [
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "WLD_NO_HARDWARE_CURSORS,1"
          "NIXOS_OZONE_WL, 1"
          "MOZ_ENABLE_WAYLAND, 1"
          "MOZ_WEBRENDER, 1"
          "XDG_SESSION_TYPE,wayland"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_RENDERER_ALLOW_SOFTWARE,1"
          "QT_QPA_PLATFORM,wayland"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"

        ];

        binds = {
          workspace_center_on = 1;
          movefocus_cycles_fullscreen = false;
        };

        input = {
          "kb_layout" = "us,ro";
          "kb_options" = "grp:alt_shift_toggle,lv3:ralt_switch";

          "natural_scroll" = "no";
          touchpad = {
            "natural_scroll" = "yes";
          };
        };

        cursor = {
          # no_hardware_cursors = "yes";
          inactive_timeout = 10;
          # no_warps = true;
          # enable_hyprcursor = "no";
        };

        misc = {
          disable_hyprland_logo = "yes";
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          new_window_takes_over_fullscreen = 2;
          middle_click_paste = false;
        };

        #
        # ========== Appearance ==========
        #
        general = {
          "gaps_in" = 6;
          "gaps_out" = 12;
          "border_size" = 2;

          # "col.active_border" = "rgba(9e5cafee) rgba(c567dcee) 45deg";
          # "col.inactive_border" = "rgba(595959aa)";

          "allow_tearing" = true;
          "resize_on_border" = true;
          "hover_icon_on_border" = true;
        };

        decoration = {
          rounding = 8;
          active_opacity = 1.0;
          inactive_opacity = 0.85;
          fullscreen_opacity = 1.0;

          blur = {
            enabled = true;
            size = 4;
            passes = 2;
            new_optimizations = true;
            popups = true;
          };

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"

            "border, 1, 10, default"
            "borderangle, 1, 8, default"

            "fade, 1, 7, default"

            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = "yes";
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        #
        # ========== Window Rules ==========
        #
        windowrule = [
          "float,stayfocused,focus,center,class:(Rofi),title:(rofi - drun)"

          # Dialogs
          "float, title:^(Open File)(.*)$"
          "float, title:^(Select a File)(.*)$"
          "float, title:^(Choose wallpaper)(.*)$"
          "float, title:^(Open Folder)(.*)$"
          "float, title:^(Save As)(.*)$"
          "float, title:^(Library)(.*)$"
          "float, title:^(Accounts)(.*)$"
        ];

        windowrulev2 = [
          "float, class:^(galculator)$"
          "float, class:^(waypaper)$"
          "float, class:^(keymapp)$"

          #
          # ========== Always opaque ==========
          #
          "opaque, class:^([Gg]imp)$"
          "opaque, class:^([Ff]lameshot)$"
          "opaque, class:^([Ii]nkscape)$"
          "opaque, class:^([Bb]lender)$"
          "opaque, class:^([Oo][Bb][Ss])$"
          "opaque, class:^([Ss]team)$"
          "opaque, class:^([Ss]team_app_*)$"
          "opaque, class:^([Vv]lc)$"

          # Remove transparency from video
          "opaque, title:^(Netflix)(.*)$"
          "opaque, title:^(.*YouTube.*)$"
          "opaque, title:^(Picture-in-Picture)$"

          # Steam rules
          "stayfocused, title:^()$,class:^([Ss]team)$"
          "minsize 1 1, title:^()$,class:^([Ss]team)$"
          "immediate, class:^([Ss]team_app_*)$"
        ];

        bind = [
          "$mod, B, exec, firefox"
          "$mod, T, exec, $terminal"
          "$mod, Q, killactive,"
          "$mod, L, exec, hyprlock"
          "$mod+Shift, L, exec, hyprlock"
          "$mod, F, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, X, exec, $menu"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          "$mod Control_L, left, workspace, e-1"
          "$mod Control_L, right, workspace, e+1"
          "$mod SHIFT, left, movetoworkspace, e-1"
          "$mod SHIFT, right, movetoworkspace, e+1"

          "$mod, Tab , cyclenext, "
          "$mod, Tab, bringactivetotop, "

          "$mod&Alt, F, fullscreen,"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod SHIFT, mouse:273, resizewindow 1"
        ];

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "$mod+Shift, L, exec, sleep 0.1 && systemctl suspend"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, light -A 10"
          ", XF86MonBrightnessDown, exec, light -U 10"

          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", Print, exec, hyprshot -m region -o Pictures/Screenshots"
          "Alt, Print, exec, hyprshot -m window -o Pictures/Screenshots"
          "$mod, Print, exec, hyprshot -m output -o Pictures/Screenshots"
        ];
      };
    };
  };
}
