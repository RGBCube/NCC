{ config, lib, pkgs, ... }: let
  inherit (lib) const genAttrs merge mkIf;
in merge {
  console.keyMap = pkgs.writeText "trq-swapped-i.map" ''
    include "${pkgs.kbd}/share/keymaps/i386/qwerty/trq.map"

    keycode 23 = i
    	altgr       keycode 23 = +icircumflex
    	altgr shift keycode 23 = +Icircumflex

    keycode 40 = +dotlessi +Idotabove
  '';

  i18n.defaultLocale = "C.UTF-8";
} <| mkIf config.isDesktop {
  i18n.extraLocaleSettings = genAttrs [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ] <| const "tr_TR.UTF-8";
}

