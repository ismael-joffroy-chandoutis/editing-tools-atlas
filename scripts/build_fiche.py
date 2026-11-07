#!/usr/bin/env python3
"""Construit la fiche des logiciels suivis, en français et en anglais, sans dépendance.

  python3 scripts/build_fiche.py   # data/logiciels.json -> docs/logiciels.html, docs/software.html
"""
import datetime, html, json, pathlib
from urllib.parse import urlparse

ROOT = pathlib.Path(__file__).resolve().parent.parent
DATA = json.loads((ROOT / "data" / "logiciels.json").read_text())
L = {
    "fr": {"file": "logiciels.html", "other": "software.html", "other_label": "English", "title": "Fiche des logiciels",
           "h1": "Quatorze logiciels pour monter et générer",
           "intro": "La note d'un cinéaste qui regarde où vont les outils de montage. Elle ne repose que sur ce que chacun publie : documentation, dépôt, page de tarifs, annonce datée. Ce n'est pas un banc d'essai : rien n'y est mesuré. Les prix changent vite, à vérifier avant de décider.",
           "atlas": "L'atlas complet", "fait": "Ce qu'il fait", "forts": "Points forts", "limites": "Limites", "pour": "À qui il sert",
           "licence": "Licence", "prix": "Prix", "date": "Relevé le", "sources": "Sources", "par": "Par",
           "foot": "Marques et noms appartiennent à leurs propriétaires. Texte sous licence CC BY-SA 4.0.", "index": "Sommaire"},
    "en": {"file": "software.html", "other": "logiciels.html", "other_label": "Français", "title": "Software notes",
           "h1": "Fourteen applications for editing and generating",
           "intro": "A filmmaker's notes on where editing tools are going. They rest only on what each publisher makes public: documentation, repository, pricing page, dated announcement. This is not a benchmark: nothing here is measured. Prices change quickly, so check before you decide.",
           "atlas": "The full atlas", "fait": "What it does", "forts": "Strengths", "limites": "Limits", "pour": "Who it is for",
           "licence": "Licence", "prix": "Price", "date": "Recorded on", "sources": "Sources", "par": "By",
           "foot": "Names and trademarks belong to their owners. Text under CC BY-SA 4.0.", "index": "Contents"},
}
CSS = """
:root{color-scheme:light dark;--bg:#f6f4ef;--fg:#1a1a18;--mute:#66625a;--line:#d8d4ca;--card:#fff;--accent:#c53a00}
@media (prefers-color-scheme:dark){:root{--bg:#111112;--fg:#ece9e2;--mute:#9b978f;--line:#2e2e30;--card:#19191b;--accent:#ff6a33}}
*{box-sizing:border-box}html{-webkit-text-size-adjust:100%;scroll-behavior:smooth}
body{margin:0;background:var(--bg);color:var(--fg);font:16px/1.55 -apple-system,BlinkMacSystemFont,"Helvetica Neue",Helvetica,Arial,sans-serif}
main{max-width:46rem;margin:0 auto;padding:2.5rem 16px 4rem}
h1{font-size:clamp(1.75rem,5vw,2.5rem);font-weight:400;line-height:1.15;margin:.5rem 0 1rem;letter-spacing:-.01em}
.lead{color:var(--mute);margin:0 0 1rem}.top{display:flex;gap:1rem;flex-wrap:wrap;font-size:.875rem;margin-bottom:1.5rem}
a{color:var(--accent);overflow-wrap:anywhere}nav.index{display:flex;flex-wrap:wrap;gap:.375rem .875rem;font-size:.875rem;padding:1rem 0;border-top:1px solid var(--line);border-bottom:1px solid var(--line);margin-bottom:2rem}
article{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:1.25rem;margin:0 0 1.25rem;scroll-margin-top:1rem}
h2{font-size:1.3rem;font-weight:500;margin:0}.meta{color:var(--mute);font-size:.875rem;margin:.125rem 0 1rem}
dl{margin:0;display:grid;grid-template-columns:7.5rem minmax(0,1fr);gap:.625rem 1rem}dt{color:var(--mute);font-size:.8125rem;padding-top:.15rem}dd{margin:0}
.src{font-size:.8125rem}.src a{margin-right:.75rem;display:inline-block}footer{color:var(--mute);font-size:.8125rem;margin-top:2rem}
@media (max-width:560px){dl{grid-template-columns:minmax(0,1fr);gap:.125rem}dd{margin-bottom:.625rem}article{padding:1rem}}
"""


def host(u):
    p = urlparse(u)
    path = p.path.strip("/")
    return p.netloc.removeprefix("www.") + ("/" + path.split("/")[0] if path else "")


def page(lang):
    t = L[lang]
    e = html.escape
    d = datetime.date.fromisoformat(DATA["date"]).strftime("%d/%m/%Y")
    idx, arts = [], []
    for s in DATA["logiciels"]:
        slug = s["nom"].lower().replace(" ", "-")
        idx.append(f'<a href="#{slug}">{e(s["nom"])}</a>')
        rows = "".join(f"<dt>{t[k]}</dt><dd>{e(s[k][lang])}</dd>" for k in ("fait", "forts", "limites", "pour", "licence", "prix"))
        rows += f"<dt>{t['date']}</dt><dd>{d}</dd>"
        src = "".join(f'<a href="{e(u)}" rel="noopener">{e(host(u))}</a>' for u in s["sources"])
        rows += f'<dt>{t["sources"]}</dt><dd class="src">{src}</dd>'
        arts.append(f'<article id="{slug}"><h2><a href="{e(s["url"])}" rel="noopener">{e(s["nom"])}</a></h2>'
                    f'<p class="meta">{e(s["type"][lang])} · {t["par"]} {e(s["editeur"])}</p><dl>{rows}</dl></article>')
    return f"""<!doctype html>
<html lang="{lang}"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; base-uri 'none'; form-action 'none'">
<title>{t['title']}</title><meta name="description" content="{e(t['intro'][:150])}"><style>{CSS}</style></head>
<body><main><div class="top"><a href="index.html">{t['atlas']}</a><a href="{t['other']}">{t['other_label']}</a></div>
<h1>{t['h1']}</h1><p class="lead">{e(t['intro'])}</p>
<nav class="index" aria-label="{t['index']}">{''.join(idx)}</nav>
{''.join(arts)}
<footer>{t['foot']}</footer></main></body></html>
"""


for lang, t in L.items():
    (ROOT / "docs" / t["file"]).write_text(page(lang))
    print(t["file"])
