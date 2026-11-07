#!/usr/bin/env python3
"""Construit l'atlas en un seul fichier HTML, sans dépendance.

  python3 scripts/build_site.py scan --list   # cherche dans les données ce qui ne doit pas sortir
  python3 scripts/build_site.py render        # data/nle.json + site/atlas.config.json -> docs/index.html

Le gabarit (site/engine/atlas.template.tpl) ne connaît aucun champ : tout passe par la configuration.
"""
import argparse, base64, json, pathlib, re, shutil, subprocess, sys, tempfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
SITE = ROOT / "site"
TEMPLATE = SITE / "engine" / "atlas.template.tpl"
DATA = ROOT / "data" / "nle.json"
OUT = ROOT / "docs" / "index.html"


# Ce qui ne doit jamais apparaître dans une page publiée. Les termes propres à un poste de
# travail vivent hors du dépôt, dans .scan-terms (une ligne : « libellé<TAB>expression »).
LEAKS = [("nom de fichier interne", r"(?<![\w/.-])[\w-]+\.(?:md|py|tpl|sh|jsonl?|html)\b")]
TERMS = ROOT / ".scan-terms"
if TERMS.exists():
    LEAKS += [tuple(l.split("\t", 1)) for l in TERMS.read_text().splitlines() if "\t" in l and not l.startswith("#")]
else:
    print("scan : pas de fichier .scan-terms, seuls les noms de fichiers sont cherchés", file=sys.stderr)


def leaves(o, path=""):
    """Toutes les chaînes d'un objet, avec leur chemin."""
    if isinstance(o, dict):
        for k, v in o.items():
            yield from leaves(v, f"{path}.{k}" if path else k)
    elif isinstance(o, list):
        for i, v in enumerate(o):
            yield from leaves(v, f"{path}.{i}")
    elif isinstance(o, str):
        yield path, o


def apply_display(o, rules, keep, path=""):
    """Copie de l'objet avec les règles d'affichage appliquées. Les sources ne sont pas touchées."""
    if isinstance(o, dict):
        return {k: apply_display(v, rules, keep, f"{path}.{k}" if path else k) for k, v in o.items()}
    if isinstance(o, list):
        return [apply_display(v, rules, keep, f"{path}.{i}") for i, v in enumerate(o)]
    if isinstance(o, str) and not re.search(keep, path):
        before = o
        for rx, to in rules:
            o = rx.sub(to, o)
        return re.sub(r"\s{2,}", " ", o).strip() if o != before else o
    return o


def display_rules(cfg):
    disp = cfg.get("display") or {}
    rules = [(re.compile(r["re"]), r["to"]) for r in disp.get("rules", [])]
    return rules, disp.get("keep", r"(^|\.)(url|capture|id)$"), disp.get("allow", [])


def find_leaks(obj, allow, keep):
    out = []
    for path, s in leaves(obj):
        if re.search(keep, path):
            continue
        txt = s
        for a in allow:
            txt = txt.replace(a, "")
        for label, rx in LEAKS:
            for m in re.finditer(rx, txt):
                out.append((label, path, txt[max(0, m.start() - 45):m.end() + 35].replace("\n", " ")))
    return out


def _shape(o):
    if isinstance(o, dict):
        return {k: _shape(v) for k, v in o.items()}
    if isinstance(o, list):
        return [_shape(v) for v in o]
    return "s" if isinstance(o, str) else o


def display_report(cfg, data, show=True):
    """Compare les données et ce que la page affichera : mêmes entrées, résidus éventuels, réécritures à reporter."""
    rules, keep, allow = display_rules(cfg)
    shown = apply_display(data, rules, keep)
    same_shape = _shape(data) == _shape(shown)
    changed = [(p, a, b) for (p, a), (_, b) in zip(leaves(data), leaves(shown)) if a != b]
    cfg_view = {k: v for k, v in cfg.items() if k != "display"}
    residue = find_leaks(shown, allow, keep) + find_leaks(cfg_view, allow, r"(^|\.)(url|src|re)$")
    if show:
        print(f"Affichage : {len(changed)} valeurs réécrites par le filtre, sources intactes, structure {'identique' if same_shape else 'DIFFÉRENTE'}.")
        print(f"Recherche de fichiers, chemins et machines : {len(residue)} résidu(s) après filtre.")
        for label, path, ctx in residue[:40]:
            print(f"  {label} : {path} : {ctx}")
    return same_shape and not residue, changed, shown


def scan(args):
    cfg = json.loads(args.config.read_text())
    data = json.loads(args.data.read_text())
    ok, changed, _ = display_report(cfg, data)
    if args.list:
        print("\nÀ réécrire dans les données plutôt que de filtrer :")
        for path, a, b in changed:
            print(f"- {path}\n    avant : {a[:220]}\n    après : {b[:220]}")
    print("Contrôle d'affichage : " + ("rien d'interne ne sort" if ok else "ÉCHEC"))
    sys.exit(0 if ok else 1)


def embed_logos(cfg, data, folder):
    """Petites icônes déjà téléchargées (scripts/fetch_logos.py), embarquées en base64. Jamais de chargement externe."""
    if not folder or not pathlib.Path(folder).is_dir():
        return {}
    hosts = set()
    for c in cfg["collections"]:
        logo = c.get("logo")
        if not logo:
            continue
        cur = data
        for k in c["path"].split("."):
            cur = cur[k]
        for it in cur:
            v = it.get(logo["path"])
            if logo.get("rules"):
                for r in logo["rules"]:
                    if re.search(r["re"], str(v or ""), re.I):
                        hosts.add(r["host"])
                        break
            elif v:
                m = re.match(r"https?://(?:www\.)?([^/]+)", v)
                if m:
                    hosts.add(m.group(1))
    out = {}
    for h in sorted(hosts):
        f = pathlib.Path(folder) / f"{h}.png"
        if f.exists():
            out[h] = "data:image/png;base64," + base64.b64encode(f.read_bytes()).decode()
    return out


def embed_images(cfg, data, data_path, width):
    """Vignettes JPEG en base64, pour que le fichier reste autonome. Ne change pas les données."""
    images, missing = {}, []
    sips = shutil.which("sips")
    tmp = pathlib.Path(tempfile.mkdtemp(dir=tempfile.gettempdir()))
    try:
        for c in cfg["collections"]:
            if not c.get("thumb"):
                continue
            cur = data
            for k in c["path"].split("."):
                cur = cur[k]
            for it in cur:
                rel = it.get(c["thumb"])
                if not rel:
                    continue
                src = data_path.parent / rel
                if not src.exists():
                    missing.append(rel)
                    continue
                out = tmp / (re.sub(r"\W+", "_", rel) + ".jpg")
                if sips:
                    subprocess.run([sips, "-Z", str(width), "-s", "format", "jpeg", "-s", "formatOptions", "60", str(src), "--out", str(out)],
                                   check=True, capture_output=True)
                else:
                    out = src
                mime = "image/jpeg" if out.suffix == ".jpg" else "image/png"
                images[rel] = f"data:{mime};base64," + base64.b64encode(out.read_bytes()).decode()
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if missing:
        print(f"captures introuvables : {missing}")
    return images


def render(args):
    cfg = json.loads(args.config.read_text())
    data = json.loads(args.data.read_text())
    images = embed_images(cfg, data, args.data, args.thumb_width) if args.embed_images else {}
    logos = embed_logos(cfg, data, args.logos)
    ok, changed, shown = display_report(cfg, data, show=False)
    if not ok:
        display_report(cfg, data)
        sys.exit("Page non écrite : du texte interne sortirait. Voir scan.")
    data = shown
    cfg = {k: v for k, v in cfg.items() if k != "display"}
    if not cfg.get("dataDate") and cfg.get("dataDatePath"):
        cur = data
        for k in cfg["dataDatePath"].split("."):
            cur = cur.get(k) if isinstance(cur, dict) else None
        cfg["dataDate"] = cur
    if cfg.get("dataVersionPath"):
        cfg["dataVersion"] = (data.get("meta") or {}).get(cfg["dataVersionPath"].split(".")[-1])
    tojson = lambda o: json.dumps(o, ensure_ascii=False, separators=(",", ":")).replace("</", "<\\/")
    esc = lambda s: str(s or "").replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;")
    html = TEMPLATE.read_text()
    html = html.replace("/*__TITLE__*/", esc(cfg.get("title"))).replace("/*__DESCRIPTION__*/", esc(cfg.get("description")))
    html = html.replace("/*__LANG__*/fr", cfg.get("lang", "fr"))
    html = html.replace("/*__CONFIG__*/null", tojson(cfg)).replace("/*__DATA__*/null", tojson(data)).replace("/*__IMAGES__*/{}", tojson(images)).replace("/*__LOGOS__*/{}", tojson(logos))
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(html)
    print(f"{args.out} : {args.out.stat().st_size / 1e6:.2f} Mo, {len(cfg['collections'])} collections, {len(images)} images et {len(logos)} logos embarqués, {len(changed)} valeurs filtrées à l'affichage")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    a = sub.add_parser("scan")
    a.add_argument("--config", type=pathlib.Path, default=SITE / "atlas.config.json")
    a.add_argument("--data", type=pathlib.Path, default=DATA)
    a.add_argument("--list", action="store_true", help="liste ce qui devrait être réécrit dans les données")
    a = sub.add_parser("render")
    a.add_argument("--config", type=pathlib.Path, default=SITE / "atlas.config.json")
    a.add_argument("--data", type=pathlib.Path, default=DATA)
    a.add_argument("--out", type=pathlib.Path, default=OUT)
    a.add_argument("--no-images", dest="embed_images", action="store_false", help="ne pas embarquer les vignettes")
    a.add_argument("--thumb-width", type=int, default=480)
    a.add_argument("--logos", type=pathlib.Path, default=SITE / "engine" / "logos", help="dossier des icônes <hôte>.png")
    args = ap.parse_args()
    {"render": render, "scan": scan}[args.cmd](args)


if __name__ == "__main__":
    main()
