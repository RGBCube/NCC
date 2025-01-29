{
  environment.shellAliases = {
    sc   = "systemctl";
    scd  = "systemctl stop";
    scr  = "systemctl restart";
    scs  = "systemctl status";
    scu  = "systemctl start";
    suc  = "systemctl --user";
    sucd = "systemctl --user stop";
    sucr = "systemctl --user restart";
    sucs = "systemctl --user status";
    sucu = "systemctl --user start";

    jc   = "journalctl";
    jcf  = "journalctl --follow --unit";
    jcr  = "journalctl --reverse --unit";
    juc  = "journalctl --user";
    jucf = "journalctl --user --follow --unit";
    jucr = "journalctl --user --reverse --unit";
  };
}
