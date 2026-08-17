import sys, json, urllib.request

RPC = "https://bsc-dataseed.binance.org"

def rpc(method, params):
    body = json.dumps({"jsonrpc":"2.0","id":1,"method":method,"params":params}).encode()
    req = urllib.request.Request(RPC, data=body, headers={"Content-Type":"application/json"})
    with urllib.request.urlopen(req, timeout=20) as r:
        res = json.loads(r.read().decode())
        if "error" in res:
            raise Exception(res["error"])
        return res["result"]

def get_storage_at(addr, slot, block="latest"):
    return rpc("eth_getStorageAt", [addr, hex(slot), block])

def eth_call(to, data, block="latest"):
    return rpc("eth_call", [{"to": to, "data": data}, block])

def get_code(addr, block="latest"):
    return rpc("eth_getCode", [addr, block])

def get_balance(addr, block="latest"):
    return rpc("eth_getBalance", [addr, block])

if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "storage":
        addr, slot = sys.argv[2], int(sys.argv[3])
        print(get_storage_at(addr, slot))
    elif cmd == "call":
        to, data = sys.argv[2], sys.argv[3]
        print(eth_call(to, data))
    elif cmd == "code":
        print(get_code(sys.argv[2]))
    elif cmd == "balance":
        print(get_balance(sys.argv[2]))
    elif cmd == "blocknum":
        print(rpc("eth_blockNumber", []))
