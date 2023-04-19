## Prerequisites

* `pxz`: Parallel LZMA compressor using XZ

## Install systemd timer

```
sudo install -m 0644 make-backup.timer /usr/lib/systemd/system/
sudo install -m 0644 make-backup.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now make-backup.timer
```

## Working with systemd timers

* validate calendar expression: `systemd-analyze calendar "*-*-* 10:00:00"`
* list timers: `systemctl list-timers`