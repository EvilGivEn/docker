#! /bin/bash
nohup warp-svc > /var/log/warp-svc.log 2>&1 &
sleep 1

o="$(warp-cli --accept-tos register)"
echo "$o"

if [[ "$o" =~ ^Success ]]; then

    o="$(warp-cli --accept-tos set-license $1)"
    echo "$o"

    if [[ "$o" =~ ^Error ]]; then
        exit 1;
    fi
fi

o="$(warp-cli --accept-tos connect)"
echo "$o";

if [[ "$o" =~ ^Success ]]; then
    v2ray run -c /etc/v2ray/config.json;
fi