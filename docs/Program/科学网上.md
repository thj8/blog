
```shell
yum -y install epel-release
yum clean all
yum -y insatll zsh vim curl wget net-tools lsof nmap-ncat.x86_64
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install --upgrade pip
pip install supervisor
pip install shadowsocks

echo_supervisord_conf > /etc/supervisord.conf

cat <<EOF >> /etc/supervisord.conf
[include]
files = /etc/supervisord.d/*.conf
EOF

mkdir /etc/supervisord.d/

cat <<EOF >> /etc/supervisord.d/ss.conf
[program:shadowesocks]
command=/usr/bin/ssserver -c /etc/shadowsocks.json
autostart=true
autorestart=true
user=root
EOF

cat <<EOF >> /etc/shadowsocks.json
{
  "server_port": 22,
  "password": "ign6el+hwyzebc",
  "method": "aes-256-cfb"
}
EOF


cat <<EOF >> /usr/lib/systemd/system/supervisord.service
[Unit]
Description=supervisor
After=syslog.target network.target

[Service]
ExecStart = /usr/bin/supervisord
User = root
Restart=on-failure
TimeoutStartSec=0
WorkingDirectory=/usr/local/

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable supervisord

supervisord
```
