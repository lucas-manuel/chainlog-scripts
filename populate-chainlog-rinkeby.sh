#!/usr/bin/env bash
set -e

[[ "$ETH_RPC_URL" && "$(seth chain)" == "rinkeby"  ]] || { echo "Please set a rinkeby ETH_RPC_URL"; exit 1;  }

CHAINLOG=0xda0ab1e0017debcd72be8599041a2aa3ba7e740f
GAS_PRICE=1000000000
ETH_GAS=500000

key_vals=$(curl https://changelog.makerdao.com/releases/rinkeby/1.0.4/contracts.json | jq -c -r 'keys[] as $k | "\($k)=\( .[$k])"')

for row in $key_vals; do
    key=$(echo $row | sed 's/=.*//')
    address=$(echo $row | sed -e 's#.*=\(\)#\1#')
    echo "Setting $key in chainlog to $address..."
    seth send $CHAINLOG 'setAddress(bytes32,address)' $(seth --to-bytes32 $(seth --from-ascii $key)) $address
    echo "$key set successfully"
done