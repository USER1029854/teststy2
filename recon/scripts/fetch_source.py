import sys, json, urllib.request, os

KEY = __import__("os").environ.get("ETHERSCAN_V2_KEY","")

def fetch(chainid, module, action, extra):
    url = f"https://api.etherscan.io/v2/api?chainid={chainid}&module={module}&action={action}&{extra}&apikey={KEY}"
    req = urllib.request.Request(url, headers={"User-Agent":"audit-script"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read().decode())

def get_source(chainid, addr):
    return fetch(chainid, "contract", "getsourcecode", f"address={addr}")

if __name__ == "__main__":
    chainid = sys.argv[1]
    addr = sys.argv[2]
    outdir = sys.argv[3]
    res = get_source(chainid, addr)
    os.makedirs(outdir, exist_ok=True)
    with open(os.path.join(outdir, "_getsourcecode_raw.json"), "w") as f:
        json.dump(res, f, indent=2)
    if res.get("status") != "1":
        print("ERROR:", res)
        sys.exit(1)
    entry = res["result"][0]
    src = entry.get("SourceCode", "")
    contract_name = entry.get("ContractName") or "Contract"
    if not src:
        print("NOT VERIFIED")
        sys.exit(2)
    # Handle multi-file JSON (sometimes double-wrapped in {{ }})
    raw = src
    if raw.startswith("{{") and raw.endswith("}}"):
        raw = raw[1:-1]
    parsed = None
    try:
        parsed = json.loads(raw)
    except Exception:
        parsed = None
    if isinstance(parsed, dict) and "sources" in parsed:
        sources = parsed["sources"]
        for path, obj in sources.items():
            content = obj.get("content", "")
            fp = os.path.join(outdir, path.lstrip("/"))
            os.makedirs(os.path.dirname(fp), exist_ok=True)
            with open(fp, "w") as f:
                f.write(content)
        print("Wrote", len(sources), "files (standard-json)")
    elif isinstance(parsed, dict):
        # flat map of filename->{content}
        for path, obj in parsed.items():
            content = obj.get("content", "") if isinstance(obj, dict) else str(obj)
            fp = os.path.join(outdir, path.lstrip("/"))
            os.makedirs(os.path.dirname(fp), exist_ok=True)
            with open(fp, "w") as f:
                f.write(content)
        print("Wrote", len(parsed), "files (flat multi-file)")
    else:
        fname = (entry.get("ContractFileName") or f"{contract_name}.sol")
        fname = os.path.basename(fname) if fname else f"{contract_name}.sol"
        if not fname.endswith(".sol"):
            fname = f"{contract_name}.sol"
        fp = os.path.join(outdir, fname)
        with open(fp, "w") as f:
            f.write(src)
        print("Wrote single file", fp)
    # Also save ABI, metadata
    meta = {k:v for k,v in entry.items() if k != "SourceCode"}
    with open(os.path.join(outdir, "_metadata.json"), "w") as f:
        json.dump(meta, f, indent=2)
    print("ContractName:", contract_name, "Proxy:", entry.get("Proxy"), "Implementation:", entry.get("Implementation"))
