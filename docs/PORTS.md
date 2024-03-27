# Internal & External Port Numbers

- 80 and 443 are standard HTTP ports. Let them be.
- Same for e-mail ports.
- 8000-8999 are internal web application ports.
  - Every app topic must use 80N0-80N9.
- 9000 is the Prometheus port.
  - Every exporter topic must use 90N0-90N9.
  - For example, Node exporter can be on 9010.
    Dovecot can be on 9020, Postfix can be on 9021,
    and so on.
- Haven't decided on redis, kresd etc. ports yet.
