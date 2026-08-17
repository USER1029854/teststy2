"""Derive Ethereum addresses from every 32-byte window in a contract's bytecode,
treating each as a secp256k1 private key, and flag matches against trusted signers.
Usage: python3 check_embedded_keys.py  (reads recon/audit/all_bytecode.json)"""
import json, sys
from coincurve import PublicKey
from Crypto.Hash import keccak

def kaddr(priv):
    try: pk = PublicKey.from_valid_secret(priv)
    except Exception: return None
    h = keccak.new(digest_bits=256); h.update(pk.format(False)[1:])
    return "0x"+h.hexdigest()[24:]

TRUSTED = {a.lower() for a in [
 "0xa22ceb70389d918899111db96dc44be66ab6ae1b","0xdeb4e4ed40e8d29d10a326fb4652fdaa55438284",
 "0xd8d76d04da5ec32d84edbd560916b1edd2194e8f","0x33992f55832af553310489e1c808be007b117063",
 "0x765e80acb2714c15e94d8c5f21b9a3380ea28fd2","0xddb8749dae93b976f73731bfc9e66663dab5fb1c"]}

def windows(code):
    b = bytes.fromhex(code[2:] if code.startswith("0x") else code)
    return {b[j:j+32] for j in range(0, len(b)-31)}

codes = json.load(open("recon/audit/all_bytecode.json"))
hits, n = [], 0
for name, code in codes.items():
    for w in windows(code):
        if any(w):
            a = kaddr(w); n += 1
            if a and a.lower() in TRUSTED: hits.append((name, w.hex(), a))
print(f"checked {n} candidates; hits: {hits or 'NONE'}")
