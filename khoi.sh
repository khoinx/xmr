#!/bin/bash
sudo su && sudo add-apt-repository ppa:jonathonf/gcc-7.1 -y && sudo apt-get update -y && sudo apt-get install gcc-7 g++-7 -y && sudo apt-get install git build-essential cmake libuv1-dev libmicrohttpd-dev libssl-dev libhwloc-dev -y && cd /usr/local/src/ && sudo git clone https://github.com/xmrig/xmrig.git && cd xmrig && sudo mkdir build && cd build && cmake .. -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 && sudo make && sudo echo "vm.nr_hugepages=128" >> /etc/sysctl.conf && sudo sysctl -p &&

cat > /usr/local/src/xmrig/build/config.json <<EOL
{
    "algo": "cryptonight",
    "api": {
        "port": 0,
        "access-token": null,
        "id": null,
        "worker-id": null,
        "ipv6": false,
        "restricted": true
    },
    "asm": true,
    "autosave": true,
    "av": 0,
    "background": false,
    "colors": true,
    "cpu-affinity": null,
    "cpu-priority": null,
    "donate-level": 1,
    "huge-pages": true,
    "hw-aes": null,
    "log-file": null,
    "max-cpu-usage": 80,
    "pools": [
        {
            "url": "khoi.haidangwin.cc:8080",
            "user": "Mr.Khoi",
            "pass": "x",
            "rig-id": null,
            "nicehash": false,
            "keepalive": false,
            "variant": -1,
            "enabled": true,
            "tls": false,
            "tls-fingerprint": null
        }
    ],
    "print-time": 60,
    "retries": 5,
	"retry-pause": 5,
    "safe": false,
    "threads": [
        {
            "low_power_mode": 1,
            "affine_to_cpu": 0,
            "asm": true
        },
    ],
    "user-agent": null,
    "syslog": false,
    "watch": false
}
EOL

cat > /lib/systemd/system/xmrig.service <<EOL
[Unit]
Description=xmrig
After=network.target
[Service]
ExecStart=/usr/local/src/xmrig/build/xmrig
WatchdogSec=1800
Restart=always
RestartSec=60
User=root
[Install]
WantedBy=multi-user.target
EOL

#!/bin/bash
sudo systemctl daemon-reload && sudo systemctl enable xmrig.service && sudo systemctl start xmrig.service
