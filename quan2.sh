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

sudo bash -c 'cat <<EOT >>/usr/local/src/xmrig/build/config.json
{
     "algo": "cryptonight",
    "api": {
        "port": 0,
        "access-token": null,
        "worker-id": null,
        "ipv6": false,
        "restricted": true
    },
    "av": 0,
    "background": false,
    "colors": true,
    "cpu-affinity": null,
    "cpu-priority": 4,
    "donate-level": 1,
    "huge-pages": true,
    "hw-aes": null,
    "log-file": null,
    "threads": 1,
    "pools": [
        {
            "url": "149.28.158.142:3333",
            "user": "46JdB5e66kFF7U9FMi5tCRArKVZtgZiteDUhC8Qqw5vUHiiMaQMia2HdW6CMD5TNwv8kLBwaoUnk2W4iBmmmf36V2nUmNRG",
            "pass": "ngoquan",
            "keepalive": true,
            "nicehash": false,
            "variant": -1,
            "tls": false,
            "tls-fingerprint": null
        }
    ],
    "print-time": 1800,
    "retries": 5,
    "retry-pause": 5,
    "safe": false,
    "syslog": false,
    "threads": null
}
EOT
' &&
sudo bash -c 'cat <<EOT >>/lib/systemd/system/quan.service 
[Unit]
Description=quan
After=network.target
[Service]
ExecStart= /usr/local/src/xmrig/build/xmrig
#WatchdogSec=300
#Restart=always
#RestartSec=10
User=root
[Install]
WantedBy=multi-user.target
EOT
' &&
sudo systemctl daemon-reload &&
sudo systemctl enable quan.service &&
sudo service quan start
