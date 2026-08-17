import sys, json, urllib.request, time
sys.path.insert(0,'recon/scripts')
from rpc import get_code

KEY=__import__("os").environ.get("ETHERSCAN_V2_KEY","")
def getsrc(addr):
    url=f"https://api.etherscan.io/v2/api?chainid=56&module=contract&action=getsourcecode&address={addr}&apikey={KEY}"
    req=urllib.request.Request(url, headers={"User-Agent":"audit"})
    for i in range(4):
        try:
            with urllib.request.urlopen(req, timeout=30) as r:
                return json.loads(r.read().decode())
        except Exception as e:
            time.sleep(2*(i+1))
    return None

addrs = sys.argv[1:]
for a in addrs:
    code = get_code(a)
    clen = (len(code)-2)//2
    if clen == 0:
        print(f"{a}  EOA (no code)")
        continue
    src = getsrc(a)
    if src and src.get("status")=="1":
        e = src["result"][0]
        name = e.get("ContractName","")
        verified = "VERIFIED" if e.get("SourceCode") else "UNVERIFIED"
        proxy = e.get("Proxy","0")
        impl = e.get("Implementation","")
        print(f"{a}  {verified}  name={name!r} proxy={proxy} impl={impl} codelen={clen}")
    else:
        print(f"{a}  ??? codelen={clen}")
    time.sleep(0.3)
