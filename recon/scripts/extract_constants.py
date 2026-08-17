import sys, re, json

def extract(hexstr):
    h = hexstr[2:] if hexstr.startswith("0x") else hexstr
    b = bytes.fromhex(h)
    # 20-byte address candidates (padded to 32 in PUSH32, or PUSH20)
    addrs = set()
    words32 = set()
    # Scan PUSH20 (0x73) and PUSH32 (0x7f)
    i = 0
    push20 = []
    push32 = []
    while i < len(b):
        op = b[i]
        if op == 0x73 and i+21 <= len(b):  # PUSH20
            val = b[i+1:i+21].hex()
            push20.append("0x"+val)
            i += 21; continue
        if op == 0x7f and i+33 <= len(b):  # PUSH32
            val = b[i+1:i+33].hex()
            push32.append("0x"+val)
            i += 33; continue
        # PUSH1..PUSH32 skip their data to avoid mis-scan
        if 0x60 <= op <= 0x7f:
            n = op - 0x5f
            i += 1 + n; continue
        i += 1
    # Address-like PUSH32 (24 leading zero hex + 40 hex)
    addr_like32 = []
    for w in push32:
        hw = w[2:]
        if hw[:24] == "0"*24 and hw[24:] != "0"*40:
            addr_like32.append("0x"+hw[24:])
    return {
        "push20": sorted(set(push20)),
        "push32": sorted(set(push32)),
        "address_like_push32": sorted(set(addr_like32)),
    }

if __name__ == "__main__":
    infile = sys.argv[1]
    hexstr = open(infile).read().strip()
    res = extract(hexstr)
    print(json.dumps(res, indent=2))
