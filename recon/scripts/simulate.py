import sys, json, urllib.request, time
from Crypto.Hash import keccak
RPC="https://bsc-dataseed.binance.org"
def rpc(method, params, retries=4):
    body=json.dumps({"jsonrpc":"2.0","id":1,"method":method,"params":params}).encode()
    for i in range(retries):
        try:
            req=urllib.request.Request(RPC, data=body, headers={"Content-Type":"application/json"})
            with urllib.request.urlopen(req, timeout=25) as r:
                return json.loads(r.read().decode())
        except Exception as e:
            if i==retries-1: raise
            time.sleep(1.5*(i+1))
def sel(s):
    h=keccak.new(digest_bits=256); h.update(s.encode()); return h.hexdigest()[:8]
def enc_addr(a): return a.lower().replace("0x","").rjust(64,'0')
def enc_uint(n): return hex(n)[2:].rjust(64,'0')

# Arbitrary unprivileged caller
CALLER="0x1111111111111111111111111111111111111111"

def simulate(name, to, sig, calldata_args=""):
    data="0x"+sel(sig)+calldata_args
    res=rpc("eth_call",[{"from":CALLER,"to":to,"data":data},"latest"])
    if "error" in res:
        msg=res["error"].get("message","")
        # try to decode revert reason from data
        return ("REVERT", msg)
    else:
        return ("OK", res.get("result","0x"))

if __name__=="__main__":
    tests = json.load(open(sys.argv[1]))
    out=[]
    for t in tests:
        status,detail = simulate(t["name"], t["to"], t["sig"], t.get("args",""))
        out.append({**t, "result":status, "detail":detail})
        print(f"[{status:6}] {t['name']:40} {t['sig']:45} :: {detail[:80]}")
        time.sleep(0.2)
    json.dump(out, open(sys.argv[2],"w"), indent=2)
