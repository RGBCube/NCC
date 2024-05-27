{ lib, ... }: with lib;

systemConfiguration {
  environment.shellAliases = {
    sc   = "systemctl";
    scd  = "systemctl stop";
    scr  = "systemctl restart";
    scu  = "systemctl start";
    suc  = "systemctl --user";
    sucd = "systemctl --user stop";
    sucr = "systemctl --user restart";
    sucu = "systemctl --user start";

    jc   = "journalctl";
    jcf  = "journalctl --follow --unit";
    jcr  = "journalctl --reverse --unit";
    juc  = "journalctl --user";
    jucf = "journalctl --user --follow --unit";
    jucr = "journalctl --user --reverse --unit";
  };
}
