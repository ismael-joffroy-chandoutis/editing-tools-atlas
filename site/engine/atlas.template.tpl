<!doctype html><html lang="/*__LANG__*/fr"><meta charset="utf-8">
<title>/*__TITLE__*/</title>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="/*__DESCRIPTION__*/">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src data:; style-src 'unsafe-inline'; script-src 'unsafe-inline'; base-uri 'none'; form-action 'none'">
<link rel="icon" href="data:,">
<style>
/* Gabarit d'atlas : barre latérale (collections, filtres), colonne centrale (carte des positions, liste), inspecteur qui suit la sélection. Sans dépendance. */
:root{
  --bg:#fbfbfd; --panel:#f5f5f7; --surface:#ffffff; --raise:#ffffff;
  --fg:#1d1d1f; --fg2:#48484c; --fg3:#6b6b70;
  --line:rgba(29,29,31,.1); --line2:rgba(29,29,31,.2);
  --accent:#0066cc; --on-accent:#ffffff; --accent-soft:rgba(0,102,204,.09);
  --warn:#a84b00; --warn-soft:rgba(168,75,0,.1);
  --glass:rgba(251,251,253,.78); --scrim:rgba(20,20,24,.28);
  --shadow:0 1px 2px rgba(0,0,0,.05),0 12px 40px rgba(0,0,0,.14);
  --heat0:rgba(0,102,204,.1); --heat1:rgba(0,102,204,.32); --heat2:rgba(0,102,204,.62); --heat3:#0066cc;
  --font:system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;
  --mono:ui-monospace,"SF Mono",Menlo,Consolas,monospace;
  --ease:cubic-bezier(.32,.72,0,1); --ease-out:cubic-bezier(.23,1,.32,1);
  --side:15rem; --insp:27rem;
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --bg:#131315; --panel:#1b1b1e; --surface:#1b1b1e; --raise:#242428;
  --fg:#f5f5f7; --fg2:#c9c9ce; --fg3:#9a9aa1;
  --line:rgba(255,255,255,.1); --line2:rgba(255,255,255,.22);
  --accent:#55a7ff; --on-accent:#08192b; --accent-soft:rgba(85,167,255,.15);
  --warn:#ffa652; --warn-soft:rgba(255,166,82,.14);
  --glass:rgba(19,19,21,.76); --scrim:rgba(0,0,0,.5);
  --shadow:0 1px 2px rgba(0,0,0,.4),0 16px 48px rgba(0,0,0,.55);
  --heat0:rgba(85,167,255,.14); --heat1:rgba(85,167,255,.36); --heat2:rgba(85,167,255,.66); --heat3:#55a7ff;
  color-scheme:dark}}
:root[data-theme="dark"]{
  --bg:#131315; --panel:#1b1b1e; --surface:#1b1b1e; --raise:#242428;
  --fg:#f5f5f7; --fg2:#c9c9ce; --fg3:#9a9aa1;
  --line:rgba(255,255,255,.1); --line2:rgba(255,255,255,.22);
  --accent:#55a7ff; --on-accent:#08192b; --accent-soft:rgba(85,167,255,.15);
  --warn:#ffa652; --warn-soft:rgba(255,166,82,.14);
  --glass:rgba(19,19,21,.76); --scrim:rgba(0,0,0,.5);
  --shadow:0 1px 2px rgba(0,0,0,.4),0 16px 48px rgba(0,0,0,.55);
  --heat0:rgba(85,167,255,.14); --heat1:rgba(85,167,255,.36); --heat2:rgba(85,167,255,.66); --heat3:#55a7ff;
  color-scheme:dark}
:root[data-theme="light"]{color-scheme:light}
*{box-sizing:border-box}
[hidden]{display:none!important}
html{-webkit-text-size-adjust:100%;height:100%}
body{margin:0;height:100%;background:var(--bg);color:var(--fg);font:400 .875rem/1.45 var(--font);-webkit-font-smoothing:antialiased;font-variant-numeric:tabular-nums}
body::before{content:"";position:fixed;inset:0 0 auto;height:env(safe-area-inset-top,0px);z-index:40;background:var(--bg)}
a{color:inherit;text-decoration:none}
button,select,input{font:inherit;color:inherit}
button{background:none;border:0;padding:0;cursor:pointer}
:focus-visible{outline:2px solid var(--accent);outline-offset:1px;border-radius:6px}
mark{background:var(--accent-soft);color:inherit;border-radius:2px}
.ico{width:1em;height:1em;flex:none;stroke:currentColor;fill:none;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round}

/* Structure */
.app{display:grid;grid-template-columns:var(--side) minmax(0,1fr);height:100%}
.side{background:var(--panel);border-right:1px solid var(--line);display:flex;flex-direction:column;min-height:0;overflow:hidden}
.side-scroll{overflow-y:auto;flex:1;min-height:0;padding:.75rem .625rem 1rem;scrollbar-width:thin}
.brand{padding:.875rem 1rem .5rem;display:flex;align-items:baseline;gap:.5rem;justify-content:space-between}
.brand h1{font-size:.9375rem;font-weight:650;letter-spacing:-.01em;margin:0}
.side-foot{border-top:1px solid var(--line);padding:.625rem .625rem .75rem;display:flex;flex-direction:column;gap:.125rem}
.foot-btn{display:flex;align-items:center;gap:.5rem;width:100%;padding:.375rem .5rem;border-radius:7px;color:var(--fg2);font-size:.8125rem;text-align:left}
.main{min-width:0;overflow-y:auto;position:relative;background:var(--bg);container:main / inline-size;scrollbar-width:thin}
.main:focus{outline:none}

/* Navigation */
.nav{display:flex;flex-direction:column;gap:1px;margin-bottom:.875rem}
.nav a span.l,.tabs a span.l{display:inline-flex;align-items:center;gap:.4375rem}
.nav a{display:flex;align-items:center;justify-content:space-between;gap:.5rem;padding:.375rem .5rem;border-radius:7px;color:var(--fg2);font-weight:500;font-size:.875rem}
.nav a .n{color:var(--fg3);font-weight:400;font-size:.8125rem}
.nav a[aria-current="page"]{background:var(--line);color:var(--fg);font-weight:600}
.nav a[aria-current="page"] .n{color:var(--fg2)}
.nav a.dim{opacity:.45}

/* Filtres */
.fgroup{padding:.125rem 0 .625rem}
.fgroup h3{font-size:.75rem;font-weight:600;color:var(--fg3);margin:.375rem .5rem .1875rem;display:flex;align-items:center;gap:.3125rem}
.opt span.l{display:inline-flex;align-items:center;gap:.375rem;min-width:0}
.opt{display:flex;align-items:center;justify-content:space-between;gap:.5rem;width:100%;padding:.25rem .5rem;border-radius:6px;color:var(--fg);font-size:.8125rem;text-align:left;min-height:1.625rem}
.opt .n{color:var(--fg3);font-size:.75rem}
.opt span:first-child{min-width:0;overflow-wrap:anywhere}
.opt[aria-pressed="true"]{background:var(--accent-soft);color:var(--accent);font-weight:550}
.opt[aria-pressed="true"] .n{color:var(--accent)}
.more{font-size:.75rem;color:var(--accent);padding:.1875rem .5rem}
@media (hover:hover) and (pointer:fine){
  .nav a:not([aria-current="page"]):hover,.opt:hover,.foot-btn:hover{background:var(--line)}
  .row:hover,.brow:hover{background:var(--line)}
  .row:hover .pick,.brow:hover .pick{opacity:1}
  .crit:not([aria-pressed="true"]):hover,.fpill:not([aria-pressed="true"]):hover,.minb:not([aria-pressed="true"]):hover,.asidel a:hover{background:var(--line)}
  .mx tbody tr:hover td{background:var(--line)}
  .mc:hover i{transform:scale(1.12)}
  .tlink:hover{text-decoration:underline}
  .btn:hover{background:var(--line)}
}

/* Barre d'outils */
.bar{position:sticky;top:0;z-index:20;background:var(--glass);-webkit-backdrop-filter:saturate(180%) blur(20px);backdrop-filter:saturate(180%) blur(20px);border-bottom:1px solid var(--line);padding:.625rem 1.25rem;padding-left:max(1.25rem,env(safe-area-inset-left,0px));padding-right:max(1.25rem,env(safe-area-inset-right,0px));display:flex;flex-wrap:wrap;align-items:center;gap:.5rem .75rem}
.count{margin:0;font-size:1.25rem;line-height:1.2;font-weight:650;letter-spacing:-.018em;margin-right:auto;min-width:0}
.search{position:relative;flex:0 1 18rem;min-width:9rem;display:flex;align-items:center}
.search .ico{position:absolute;left:.5625rem;color:var(--fg3);pointer-events:none}
.search input{width:100%;height:2rem;border:1px solid var(--line);border-radius:8px;background:var(--surface);padding:0 1.875rem 0 1.875rem;outline:none;-webkit-appearance:none;appearance:none;font-size:.875rem}
.search input::-webkit-search-cancel-button{display:none}
.search input:focus{border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
.search kbd{position:absolute;right:.5rem;font:500 .6875rem var(--mono);color:var(--fg3);border:1px solid var(--line2);border-radius:4px;padding:0 .3125rem;line-height:1.1rem;pointer-events:none}
.search button{position:absolute;right:.375rem;color:var(--fg3);display:flex;padding:.25rem}
.seg{display:inline-flex;background:var(--line);border-radius:8px;padding:2px;flex:none}
.seg a,.seg button{padding:.1875rem .625rem;border-radius:6px;font-size:.8125rem;font-weight:500;color:var(--fg2);display:flex;gap:.3125rem;align-items:center;white-space:nowrap;min-height:1.625rem}
.seg [aria-current="true"],.seg [aria-pressed="true"]{background:var(--raise);color:var(--fg);box-shadow:0 1px 2px rgba(0,0,0,.14)}
.selectwrap{position:relative;display:inline-flex;align-items:center;gap:.375rem;font-size:.8125rem;color:var(--fg3);min-width:0}
.selectwrap select{-webkit-appearance:none;appearance:none;background:transparent;border:0;padding:.25rem 1.125rem .25rem .125rem;color:var(--fg);font-weight:500;cursor:pointer;max-width:15rem;text-overflow:ellipsis;font-size:.8125rem;outline-offset:0;field-sizing:content}
.selectwrap .ico{position:absolute;right:0;pointer-events:none;width:.75rem;height:.75rem;color:var(--fg3)}
.btn{display:inline-flex;align-items:center;gap:.375rem;padding:.25rem .625rem;border-radius:7px;font-size:.8125rem;font-weight:500;color:var(--fg);border:1px solid var(--line2);min-height:1.875rem;transition:transform 120ms var(--ease-out)}
.btn:active,.opt:active,.seg a:active,.seg button:active{transform:scale(.97)}
.btn.primary{background:var(--accent);color:var(--on-accent);border-color:transparent}
.btn[aria-pressed="true"]{background:var(--accent-soft);color:var(--accent);border-color:transparent}
.m-only{display:none}
.row .title{color:inherit}
.row .title::after{content:"";position:absolute;inset:0;border-radius:8px}
.row .title:focus-visible{outline:none}
.row .title:focus-visible::after{outline:2px solid var(--accent);outline-offset:-2px}
.row .pick{position:relative;z-index:1}
.row .cell{pointer-events:none}
.chips{display:flex;flex-wrap:wrap;gap:.3125rem;align-items:center;padding:.5rem 1.25rem 0}
.chip{display:inline-flex;align-items:center;gap:.25rem;padding:.0625rem .25rem .0625rem .5625rem;background:var(--accent-soft);color:var(--accent);border-radius:99px;font-size:.75rem;font-weight:500}
.chip .ico{width:.8125rem;height:.8125rem}
.tlink{color:var(--accent)}
.fresh{padding:.5rem 1.25rem .375rem;color:var(--fg3);font-size:.75rem;display:flex;gap:.375rem;align-items:baseline;flex-wrap:wrap}
.fresh b{font-weight:400;color:var(--fg3)}
.fresh.old{color:var(--warn);background:var(--warn-soft);margin:.625rem 1.25rem 0;padding:.375rem .625rem;border-radius:8px;font-weight:500;gap:.375rem .5rem;align-items:center}
.fresh.old b{color:var(--warn);font-weight:400}
.fresh.old .ico{font-size:.9375rem}

/* Classement */
.board{padding:.625rem 1.25rem 1.5rem}
.leaders{display:grid;grid-template-columns:repeat(auto-fit,minmax(12rem,1fr));gap:.375rem;margin-bottom:.875rem}
.leader{display:flex;gap:.5rem;align-items:center;min-width:0;padding:.4375rem .625rem;border-radius:10px;background:var(--panel);font-size:.75rem;color:var(--fg3)}
.leader .ico{font-size:1rem;color:var(--fg2)}
.leader b{display:block;color:var(--fg);font-weight:550;font-size:.8125rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.leader div{min-width:0}
.crits,.fpills{display:flex;flex-wrap:wrap;gap:.25rem;align-items:center}
.crit,.fpill,.minb{display:inline-flex;align-items:center;gap:.3125rem;padding:.1875rem .625rem;min-height:1.75rem;border-radius:99px;font-size:.8125rem;font-weight:500;color:var(--fg2);box-shadow:inset 0 0 0 1px var(--line);transition:background-color 140ms ease,color 140ms ease}
.crit[aria-pressed="true"]{background:var(--fg);color:var(--bg);box-shadow:none}
.fpill[aria-pressed="true"],.minb[aria-pressed="true"]{background:var(--accent-soft);color:var(--accent);box-shadow:none}
.fpills{margin-top:.5rem}
.fpills .lbl{font-size:.75rem;color:var(--fg3);margin:0 .25rem 0 .625rem}
.bnote{margin:.625rem 0 .25rem;font-size:.75rem;line-height:1.45;color:var(--fg3);max-width:82ch}
.bnote p{margin:.1875rem 0}
.bnote a{color:var(--accent)}
.bnote strong{font-weight:550;color:var(--fg2)}
.flleg{display:flex;flex-wrap:wrap;gap:.125rem .75rem;margin-top:.375rem!important}
.flleg span{display:inline-flex;align-items:center;gap:.25rem}
#bexpl{margin-top:.875rem}
.brows{margin-top:.375rem;--fw:4rem}
.brows.just .nm small{white-space:normal;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical}
.brows.just .bf{visibility:hidden}
.brow{display:grid;grid-template-columns:2.125rem 1.75rem minmax(0,1.5fr) var(--fw) minmax(4.5rem,1fr) 5.25rem 1.625rem;gap:.625rem;align-items:center;min-height:3rem;padding:.3125rem .375rem;position:relative;border-radius:8px;background:var(--bg)}
.brow + .brow::before{content:"";position:absolute;left:.375rem;right:.375rem;top:0;height:1px;background:var(--line)}
.brow.sel,.brow.cur{background:var(--accent-soft)}
.brow .rk{font-size:1rem;font-weight:600;letter-spacing:-.01em;text-align:right;white-space:nowrap}
.brow .rk small{font-size:.75rem;font-weight:400;color:var(--fg3);margin-right:.0625rem}
.brow .nm{min-width:0;color:inherit}
.brow .nm::after{content:"";position:absolute;inset:0;border-radius:8px}
.brow .nm:focus-visible{outline:none}
.brow .nm:focus-visible::after{outline:2px solid var(--accent);outline-offset:-2px}
.brow .nm b{font-weight:550;font-size:.9375rem;letter-spacing:-.005em;display:block;line-height:1.25;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.brow .nm small{font-size:.75rem;color:var(--fg3);display:block;line-height:1.3;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.brow .tagmini{font-size:.6875rem;font-weight:500;padding:0 .3125rem;border-radius:4px;background:var(--line);color:var(--fg2);margin-left:.3125rem;line-height:1.0625rem;display:inline-block;vertical-align:.0625rem;position:relative;z-index:1}
.brow .tagmini.warn{background:var(--warn-soft);color:var(--warn)}
.track{position:relative;height:.25rem;border-radius:99px;background:var(--line)}
.track .fill{position:absolute;inset:0 auto 0 0;border-radius:99px;background:var(--accent);transition:width 340ms var(--ease);min-width:2px}
.track .wh{position:absolute;top:-.1875rem;bottom:-.1875rem;border-inline:1px solid var(--fg2);opacity:.55;transition:left 340ms var(--ease),width 340ms var(--ease);background:linear-gradient(var(--fg2),var(--fg2)) center/100% 1px no-repeat}
.brow .val{text-align:right;line-height:1.15;white-space:nowrap}
.brow .val b{font-size:.9375rem;font-weight:600;letter-spacing:-.01em;display:block}
.brow .val small{font-size:.6875rem;color:var(--fg3);display:block}
.brow .pick{opacity:.55}
.bfoot{display:flex;flex-wrap:wrap;gap:.5rem;align-items:center;margin-top:.625rem}
.aside{margin-top:1rem;border-top:1px solid var(--line);padding-top:.625rem;font-size:.8125rem;color:var(--fg2)}
.aside summary{cursor:pointer;font-weight:550;color:var(--fg);list-style-position:outside}
.aside h4{font-size:.75rem;font-weight:600;color:var(--fg3);margin:.625rem 0 .25rem}
.asidel{display:flex;flex-wrap:wrap;gap:.25rem}
.asidel a{display:inline-flex;gap:.25rem;align-items:baseline;padding:.0625rem .5rem;border-radius:6px;box-shadow:inset 0 0 0 1px var(--line);font-size:.75rem;color:var(--fg2)}
.asidel a small{color:var(--fg3);font-size:.6875rem}
.callout{margin:.5rem 0 .75rem;padding:.5rem .625rem;border-radius:8px;background:var(--panel);font-size:.8125rem;line-height:1.4;color:var(--fg2)}
.callout a{color:var(--accent)}
.rankt td:last-child{text-align:right;white-space:nowrap}
.ihd{display:flex;gap:.625rem;align-items:flex-start}
.ihd .lg{width:2.25rem;height:2.25rem;margin-top:.125rem}

/* Matrice */
.mxw{padding:.5rem 1.25rem 1.5rem}
.mx{border-collapse:separate;border-spacing:0;width:100%;table-layout:fixed;font-size:.8125rem}
.mx col.n{width:auto}.mx col.c{width:5.25rem}.mx col.t{width:4.5rem}
.mx .ls{display:none}
.mx thead th{position:sticky;top:var(--bar-h,3.3125rem);z-index:3;background:var(--bg);font-weight:500;font-size:.6875rem;color:var(--fg3);padding:.375rem 0;border-bottom:1px solid var(--line2);vertical-align:bottom;text-align:center;line-height:1.1}
.mx thead th:first-child{text-align:left}
.mx thead button{font-size:inherit;font-weight:inherit;width:100%;padding:.125rem 0;overflow:hidden;text-overflow:ellipsis}
.mx thead button[aria-pressed="true"]{color:var(--fg);font-weight:650}
.mx tbody td{padding:.125rem 0;border-bottom:1px solid var(--line);text-align:center}
.mx tbody td:first-child{text-align:left}
.mx .nm{display:flex;align-items:center;gap:.5rem;min-width:0;padding-right:.5rem;color:inherit}
.mx .nm span.t{min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:500}
.mx tr.under .nm span.t{color:var(--fg3);font-weight:400}
.mx tr.sep td{font-size:.75rem;color:var(--fg3);text-align:left!important;padding:.75rem 0 .25rem;border-bottom:1px solid var(--line2)}
.mx .lg{width:1.375rem;height:1.375rem;border-radius:5px;font-size:.5625rem}
.mx .lg img{padding:2px}
.mc{display:inline-flex;padding:.1875rem}
.mc i{width:1.625rem;height:1.625rem;border-radius:5px;display:flex;align-items:center;justify-content:center;font:600 .75rem/1 var(--font);font-style:normal;color:var(--fg2);transition:transform 120ms var(--ease-out)}
.mx .tot{font-weight:600;white-space:nowrap}
.mx .tot small{display:block;font-weight:400;font-size:.625rem;color:var(--fg3)}
.mapnote{font-size:.75rem;line-height:1.45;color:var(--fg3);margin:.375rem 0 .25rem;max-width:82ch}
.mapnote a{color:var(--accent)}
.map .frontl{fill:none;stroke:var(--accent);stroke-width:1.25;opacity:.45;stroke-linejoin:round}
.map .pt.front .dot{stroke-width:2.5}
.map .better text{fill:var(--fg2);font-weight:500}
.map .better path{stroke:var(--fg2);fill:none;stroke-width:1.25;stroke-linecap:round;stroke-linejoin:round}
.legend i.line{width:1.125rem;height:0;border-radius:0;border:0;border-top:1.5px solid var(--accent);opacity:.6;vertical-align:.1875rem}

/* Carte */
.mapwrap{padding:.625rem 1.25rem 0}
.maphead{display:flex;flex-wrap:wrap;gap:.25rem .875rem;align-items:center;font-size:.8125rem;color:var(--fg3);margin-bottom:.25rem}
.maphead .right{margin-left:auto}
.legend{display:inline-flex;gap:.75rem;align-items:center}
.legend i{display:inline-block;width:.625rem;height:.625rem;border-radius:50%;border:1.5px solid var(--accent);margin-right:.25rem;vertical-align:-1px}
.legend i.on{background:var(--accent)}
.map{position:relative;height:clamp(19rem,46vh,36rem);border-bottom:1px solid var(--line);margin-bottom:.25rem}
.map svg{display:block;width:100%;height:100%;overflow:visible;touch-action:manipulation}
.map text{fill:var(--fg3);font:400 11px var(--font);font-variant-numeric:tabular-nums}
.map .grid{stroke:var(--line);stroke-width:1;shape-rendering:crispEdges}
.map .axis{stroke:var(--line2);stroke-width:1;shape-rendering:crispEdges}
.map .atitle{fill:var(--fg3);font-size:11px;font-weight:500}
.map .pt{cursor:pointer;transition:transform 260ms var(--ease)}
.map svg.noanim .pt{transition:none}
.map .pt .dot{fill:var(--surface);stroke:var(--accent);stroke-width:1.5}
.map .pt.on .dot{fill:var(--accent);stroke:var(--bg)}
.map .pt .hit{fill:transparent;stroke:none}
.map .pt.hot .dot,.map .pt.sel .dot{stroke:var(--fg);stroke-width:2}
.map .lab{fill:var(--fg);font:500 11px var(--font);pointer-events:none;paint-order:stroke;stroke:var(--bg);stroke-width:3px;stroke-linejoin:round}
.map .labs{transition:opacity 180ms ease}
.tip{position:absolute;z-index:6;pointer-events:none;background:var(--raise);border:1px solid var(--line);border-radius:9px;box-shadow:var(--shadow);padding:.4375rem .625rem;font-size:.75rem;max-width:17rem;line-height:1.35}
.tip b{display:block;font-weight:600;font-size:.8125rem}
.tip span{color:var(--fg2);display:block}
.mapnone{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:var(--fg3);text-align:center;padding:1rem}

/* Liste */
.list{padding:0 .75rem 1.5rem}
.thead,.row{display:flex;gap:.875rem;align-items:center;padding-inline:.5rem}
.thead > *,.row > *{min-width:0}
.c-name{flex:1.7 1 14rem}
.c-pick{flex:0 0 1.75rem;display:flex;justify-content:center}
.thead{position:sticky;top:var(--bar-h,3.3125rem);z-index:10;background:var(--bg);font-size:.75rem;color:var(--fg3);font-weight:500;border-bottom:1px solid var(--line);min-height:2rem}
.thead button{color:inherit;font-weight:inherit;display:inline-flex;gap:.1875rem;align-items:center;text-align:left;font-size:inherit;padding:.25rem 0}
.thead .r,.row .r{text-align:right}
.thead .r button{justify-content:flex-end;width:100%}
.thead .r button{text-align:right}
.thead [aria-sort]:not([aria-sort="none"]) button{color:var(--fg)}
.row{min-height:3.1875rem;border-radius:8px;padding-block:.375rem;border-bottom:1px solid transparent;position:relative}
.row + .row::before{content:"";position:absolute;left:.5rem;right:.5rem;top:0;height:1px;background:var(--line)}
.row.sel,.row.cur{background:var(--accent-soft)}
.row.cur:not(.sel){box-shadow:inset 0 0 0 1.5px var(--accent-soft)}
.row.sel::before,.row.sel + .row::before{opacity:0}
.cell{min-width:0;font-size:.8125rem;color:var(--fg2);overflow:hidden;text-overflow:ellipsis;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;line-height:1.3}
.cell.r{font-size:.875rem;color:var(--fg);overflow:visible;text-align:right}
.title{min-width:0;display:flex;gap:.625rem;align-items:center}
.title .tx{min-width:0}
.title b{font-weight:550;font-size:.9375rem;letter-spacing:-.005em;display:block;line-height:1.25;overflow-wrap:anywhere}
.title small{font-size:.75rem;color:var(--fg3);display:block;line-height:1.3;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.thumb.tph{display:inline-flex;align-items:center;justify-content:center;background:var(--panel)}
.thumb{width:4.75rem;height:3rem;flex:none;border-radius:6px;object-fit:cover;object-position:top;background:var(--line);border:1px solid var(--line)}
.pick{width:1.625rem;height:1.625rem;border-radius:50%;display:flex;align-items:center;justify-content:center;color:var(--fg3);opacity:0;transition:opacity 120ms ease,background-color 120ms ease}
.pick:focus-visible,.pick[aria-pressed="true"]{opacity:1}
.pick[aria-pressed="true"]{background:var(--accent);color:var(--on-accent)}
.mute{color:var(--fg3)}
.q{color:var(--fg3);opacity:.7}
.tag{display:inline-block;padding:0 .4375rem;border-radius:5px;font-size:.75rem;line-height:1.25rem;background:var(--line);color:var(--fg2);font-weight:500;white-space:nowrap}
.tag.good{background:var(--accent-soft);color:var(--accent)}
.tag.warn{background:var(--warn-soft);color:var(--warn)}
.badge{display:inline-block;margin:0 .25rem .0625rem 0;color:var(--fg2);white-space:nowrap}
.heat{display:inline-flex;gap:2px;vertical-align:middle}
.heat i{width:1.125rem;height:1.125rem;border-radius:4px;display:flex;align-items:center;justify-content:center;font:600 .6875rem/1 var(--font);font-style:normal;color:var(--fg2)}
.heat i.v0,.mc i.v0{background:var(--heat0)}.heat i.v1,.mc i.v1{background:var(--heat1);color:var(--fg)}.heat i.v2,.mc i.v2{background:var(--heat2);color:var(--on-accent)}.heat i.v3,.mc i.v3{background:var(--heat3);color:var(--on-accent)}
.heat i.vn,.mc i.vn{background:transparent;outline:1px dashed var(--line2);outline-offset:-1px}
.row .heat,.row .fl,.brow .heat,.brow .fl,.brow .mk,.row .mk{position:relative;z-index:1;pointer-events:auto}
.hleg{display:inline-flex;flex-wrap:wrap;gap:.25rem .625rem;align-items:center;font-size:.75rem;color:var(--fg3)}
.hleg span{display:inline-flex;align-items:center;gap:.25rem}
.fl{display:inline-flex;width:1.125rem;height:1.125rem;align-items:center;justify-content:center;font-size:.9375rem;vertical-align:middle;color:var(--fg)}
.fl.p{color:var(--fg2)}.fl.u{color:var(--fg3);opacity:.5}.fl.n{color:var(--fg3);opacity:.22}
.flags{display:inline-flex;gap:.1875rem;vertical-align:middle}
.mk{display:inline-flex;vertical-align:-.125em;margin-left:.3125rem;color:var(--accent);font-size:.9375rem}
.lg{width:1.75rem;height:1.75rem;flex:none;border-radius:7px;display:inline-flex;align-items:center;justify-content:center;overflow:hidden;background:#fff;box-shadow:0 0 0 1px var(--line);font:600 .6875rem/1 var(--font);color:#55555a;letter-spacing:-.01em}
.lg img{width:100%;height:100%;object-fit:contain;padding:3px;display:block}
.lg.mono{background:var(--panel);color:var(--fg2)}
.gtip{position:fixed;z-index:60;pointer-events:none;background:var(--raise);border:1px solid var(--line);border-radius:9px;box-shadow:var(--shadow);padding:.375rem .5625rem;font-size:.75rem;line-height:1.35;max-width:19rem;color:var(--fg)}
.empty{padding:3rem 1.25rem;color:var(--fg2);max-width:34rem}
.empty h3{margin:0 0 .375rem;font-size:1.0625rem;font-weight:600;color:var(--fg)}
.empty a{color:var(--accent)}
.empty p{margin:.25rem 0}
.sentinel{height:1px}

/* Inspecteur et feuilles */
.scrim{position:fixed;inset:0;background:var(--scrim);z-index:30;opacity:0;pointer-events:none;transition:opacity 200ms ease}
.scrim.show{opacity:1;pointer-events:auto}
.sheet{position:fixed;z-index:31;background:var(--surface);box-shadow:var(--shadow);overflow-y:auto;overscroll-behavior:contain;top:0;right:0;bottom:0;width:min(30rem,100%);transform:translateX(102%);transition:transform 240ms var(--ease);visibility:hidden;scrollbar-width:thin}
.sheet.show{transform:none;visibility:visible}
.sheet:not(.show){transition:transform 180ms var(--ease),visibility 0s 180ms}
.kbd .sheet,.kbd .scrim,.kbd .sheet:not(.show){transition:none}
.ihead{position:sticky;top:0;z-index:3;background:var(--glass);-webkit-backdrop-filter:saturate(180%) blur(20px);backdrop-filter:saturate(180%) blur(20px);display:flex;align-items:center;gap:.375rem;padding:.625rem .875rem;padding-top:calc(.625rem + env(safe-area-inset-top,0px));border-bottom:1px solid var(--line)}
.ihead .sp{flex:1}
.icobtn{width:2rem;height:2rem;display:flex;align-items:center;justify-content:center;border-radius:50%;color:var(--fg2);font-size:1rem;flex:none}
.ibody{padding:1rem 1.25rem 3rem;padding-left:max(1.25rem,env(safe-area-inset-left,0px));padding-right:max(1.25rem,env(safe-area-inset-right,0px))}
.ibody h2{font-size:1.5rem;line-height:1.14;font-weight:650;letter-spacing:-.022em;margin:0;text-wrap:balance;overflow-wrap:anywhere}
.isub{color:var(--fg3);margin:.25rem 0 .625rem;font-size:.875rem}
.itags{display:flex;gap:.3125rem;flex-wrap:wrap;margin-bottom:.75rem}
.ishot{width:100%;max-width:15rem;display:block;border-radius:10px;border:1px solid var(--line);margin:.25rem 0 .875rem;background:var(--line);max-height:9.5rem;object-fit:cover;object-position:top}
.ishotlink{display:inline-block;max-width:15rem}
.ikey{display:grid;grid-template-columns:repeat(auto-fit,minmax(6.5rem,1fr));gap:.625rem .875rem;margin:.625rem 0 .25rem;padding:.75rem 0;border-block:1px solid var(--line)}
.ikey dt{font-size:.6875rem;color:var(--fg3)}
.ikey dd{margin:0;font-size:1rem;font-weight:600;letter-spacing:-.01em;overflow-wrap:anywhere;line-height:1.25}
.isec{margin-top:1.25rem}
.isec > h3{font-size:.8125rem;font-weight:650;margin:0 0 .375rem;letter-spacing:-.003em}
.fields{margin:0;display:grid;grid-template-columns:minmax(6.5rem,10.5rem) minmax(0,1fr);gap:.3125rem .75rem;font-size:.8125rem}
.fields dt{color:var(--fg3);line-height:1.4}
.fields dd{margin:0;color:var(--fg);overflow-wrap:anywhere;min-width:0;line-height:1.4}
.fields .full{grid-column:1 / -1}
.fields dd dl.fields{display:block;padding-left:.625rem;border-left:1px solid var(--line)}
.fields dd dl.fields dt{font-size:.75rem;margin-top:.25rem}
.fields dd dl.fields dt:first-child{margin-top:0}
.ul.recs{gap:.625rem}
.ul.recs > li{padding-left:0}
.ul.recs > li::before{display:none}
.ul{margin:0;padding:0;list-style:none;font-size:.8125rem;display:grid;gap:.25rem}
.ul li{padding-left:.75rem;position:relative;overflow-wrap:anywhere}
.ul li::before{content:"";position:absolute;left:0;top:.5625em;width:.25rem;height:.25rem;border-radius:50%;background:var(--fg3)}
.srcs{list-style:none;margin:0;padding:0;display:grid;gap:.25rem;font-size:.75rem}
.srcs a{color:var(--accent);overflow-wrap:anywhere}
.srcs small{color:var(--fg3);font-size:.6875rem;margin-left:.25rem}
.tw{overflow-x:auto;margin:.125rem -.25rem 0;scrollbar-width:thin}
.t{border-collapse:collapse;font-size:.75rem;min-width:100%}
.t th,.t td{padding:.3125rem .4375rem;text-align:left;border-bottom:1px solid var(--line);vertical-align:top}
.t th{font-weight:500;color:var(--fg3);white-space:nowrap;position:sticky;top:0}
.t td.n,.t th.n{text-align:right;white-space:nowrap}
.scorerow{display:flex;gap:.5rem;align-items:baseline}
.scorerow .heat{flex:none;transform:translateY(1px)}
.expired{color:var(--warn);font-weight:500}

/* Comparaison */
.tray{position:sticky;z-index:25;bottom:0;background:var(--bg);border-top:1px solid var(--line2);padding:.4375rem 1.25rem calc(.4375rem + env(safe-area-inset-bottom,0px));display:flex;align-items:center;gap:.625rem;font-size:.8125rem}
.tray.off{display:none}
.tray .names{min-width:0;flex:1;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;color:var(--fg2)}
.cmp{padding:1rem 1.25rem 0;padding-left:max(1.25rem,env(safe-area-inset-left,0px));padding-right:max(1.25rem,env(safe-area-inset-right,0px))}
.cmp-head{display:flex;flex-wrap:wrap;gap:.5rem .75rem;align-items:center;margin-bottom:.75rem}
.cmp-head h2{margin:0 auto 0 0;font-size:1.25rem;font-weight:650;letter-spacing:-.018em}
.cmpt{overflow:auto;border-top:1px solid var(--line);max-height:calc(100vh - 5.5rem);scrollbar-width:thin}
.ctab{border-collapse:separate;border-spacing:0;width:100%;table-layout:fixed;font-size:.8125rem;--cw:15rem}
.ctab col.lb{width:10.5rem}
.ctab col.v{width:var(--cw)}
.ctab th,.ctab td{padding:.4375rem .75rem;vertical-align:top;text-align:left;border-bottom:1px solid var(--line);overflow-wrap:anywhere}
.ctab thead th{position:sticky;top:0;z-index:2;background:var(--bg);font-weight:600;font-size:.9375rem;letter-spacing:-.01em}
.ctab thead th a{display:block;line-height:1.2}
.ctab thead th small{display:block;font-weight:400;font-size:.75rem;color:var(--fg3);letter-spacing:0;margin-top:.125rem}
.ctab tbody th{position:sticky;left:0;background:var(--bg);font-weight:400;color:var(--fg3);z-index:1}
.ctab thead th:first-child{left:0;z-index:3}
.ctab .sect th{font-weight:650;color:var(--fg);padding-top:1.125rem;font-size:.8125rem;border-bottom:1px solid var(--line2);position:static}
.rm{color:var(--fg3);font-size:.75rem;font-weight:400;display:inline-flex;gap:.1875rem;align-items:center;margin-top:.25rem}

/* A propos */
.about{padding:.25rem 0 1rem;font-size:.875rem}
.about p{max-width:60ch;margin:.375rem 0}
.about h3{font-size:.8125rem;font-weight:650;margin:1.25rem 0 .375rem}
.about a{color:var(--accent)}
kbd.k{font:500 .6875rem var(--mono);border:1px solid var(--line2);border-radius:4px;padding:0 .3125rem;color:var(--fg2)}
.skip{position:absolute;left:-999px}
.skip:focus{left:.5rem;top:.5rem;z-index:50;background:var(--raise);padding:.5rem .75rem;border-radius:8px}

/* Grands écrans : l'inspecteur devient une colonne */
@media (min-width:1200px){
  .app.docked{grid-template-columns:var(--side) minmax(0,1fr) var(--insp)}
  .sheet.insp{position:relative;inset:auto;width:auto;box-shadow:none;border-left:1px solid var(--line);transform:none;transition:none;z-index:1;height:100%}
  .sheet.insp:not(.show){display:none}
  .scrim.for-insp{display:none}
}

/* Etroit : colonne unique, défilement du document */
@media (max-width:899px){
  html,body{height:auto}
  .app{display:block;height:auto}
  .side{display:contents}
  .side-scroll,.side-foot{display:none}
  .brand{padding:.75rem max(1rem,env(safe-area-inset-right,0px)) 0 max(1rem,env(safe-area-inset-left,0px));align-items:center}
  .brand h1{font-size:1.0625rem}
  .main{overflow:visible;container:main / inline-size}
  .m-only{display:inline-flex}
  .d-only{display:none}
  .topnav{position:sticky;top:env(safe-area-inset-top,0px);z-index:20;background:var(--glass);-webkit-backdrop-filter:saturate(180%) blur(20px);backdrop-filter:saturate(180%) blur(20px);border-bottom:1px solid var(--line);padding-top:.5rem}
  .toprow{display:flex;gap:.5rem;align-items:center;padding:0 max(1rem,env(safe-area-inset-right,0px)) 0 max(1rem,env(safe-area-inset-left,0px))}
  .toprow .search{flex:1 1 auto}
  .search input{height:2.375rem;font-size:1rem;border-radius:10px}
  .search kbd{display:none}
  .tabs{display:flex;gap:.25rem;overflow-x:auto;padding:.4375rem max(1rem,env(safe-area-inset-right,0px)) .4375rem max(1rem,env(safe-area-inset-left,0px));scrollbar-width:none;-webkit-overflow-scrolling:touch}
  .tabs::-webkit-scrollbar{display:none}
  .tabs a{flex:none;padding:.25rem .625rem;border-radius:99px;font-weight:500;font-size:.875rem;color:var(--fg2);display:flex;gap:.3125rem;min-height:1.875rem;align-items:center}
  .tabs a .n{color:var(--fg3);font-size:.75rem;font-weight:400}
  .tabs a[aria-current="page"]{background:var(--fg);color:var(--bg)}
  .tabs a[aria-current="page"] .n{color:inherit;opacity:.75}
  .bar{position:static;background:none;-webkit-backdrop-filter:none;backdrop-filter:none;border:0;padding:.75rem max(1rem,env(safe-area-inset-right,0px)) .25rem max(1rem,env(safe-area-inset-left,0px))}
  .count{width:100%;font-size:1.5rem;margin-right:0}
  .bar .right-sp{margin-left:auto}
  .chips,.fresh{padding-inline:max(1rem,env(safe-area-inset-right,0px)) max(1rem,env(safe-area-inset-left,0px));padding-inline:1rem}
  .mapwrap{padding-inline:1rem}
  .map{height:min(70vw,24rem)}
  .list{padding-inline:.5rem}
  .thead{display:none}
  .sheet{width:100%;transform:translateY(102%)}
  .sheet.side-sheet{top:auto;height:86%;border-radius:14px 14px 0 0}
  .cmp{padding-inline:1rem}
  .ctab{--cw:max(8.25rem,calc((100vw - 7rem)/2))}
  .ctab col.lb{width:5rem}
  .ctab th,.ctab td{padding:.4375rem .5rem}
  .cmpt{max-height:none}
  .ctab thead th{top:calc(env(safe-area-inset-top,0px))}
  .board,.mxw{padding-inline:1rem}
  .fresh.old{margin-inline:1rem}
  body.locked{overflow:hidden}
}
@media (min-width:900px){.topnav{display:contents}.toprow,.tabs{display:none}}

/* Colonnes selon la largeur disponible */
.ph small{display:none}
@container main (max-width:880px){.search{flex-basis:11rem}#sortwrap > span{display:none}}
@container main (max-width:880px){.p3{display:none!important}}
@container main (max-width:980px){.mx col.c{width:2.5rem}.mx .ll{display:none}.mx .ls{display:inline}}
@container main (max-width:760px){.brow{grid-template-columns:2rem 1.75rem minmax(0,1.4fr) minmax(3.5rem,.8fr) 4.75rem 1.5rem}.brow .bf{display:none}}
@container main (max-width:560px){
  .brow{grid-template-columns:1.625rem 1.75rem minmax(0,1fr) auto;grid-template-areas:"rk lg nm val" ". . tr tr";gap:.1875rem .5rem;padding-block:.5rem .625rem}
  .brow .rk{grid-area:rk}.brow .lg{grid-area:lg}.brow .nm{grid-area:nm}.brow .val{grid-area:val}.brow .track{grid-area:tr}
  .brow .pick{display:none}
  .brow .rk{font-size:.9375rem}
  .brow .nm b{white-space:normal}
  .leaders{display:none}
  .crits,.fpills{flex-wrap:nowrap;overflow-x:auto;scrollbar-width:none;margin-inline:-1rem;padding-inline:1rem;-webkit-overflow-scrolling:touch}
  .crits::-webkit-scrollbar,.fpills::-webkit-scrollbar{display:none}
  .crit,.fpill,.minb{flex:none}
  .fpills .lbl{flex:none}
  .fresh.old b{display:none}
  .board{padding-top:.5rem}
  .hlegw{display:none}
  .mx col.c{width:1.8125rem}.mx col.t{width:3rem}
  .mx .ll{display:none}.mx .ls{display:inline}
  .mc{padding:.125rem}.mc i{width:1.375rem;height:1.375rem;font-size:.6875rem}
  .mx .lg{display:none}
  .mx thead th{font-size:.5625rem}
  .fpills .lbl{margin-left:0}
}
@container main (max-width:640px){.p2{display:none!important}}
@container main (max-width:560px){
  .row{min-height:3.5rem}
  .row .title{flex:1 1 auto}
  .row .cell:not(.ph){display:none!important}
  .row .cell.ph{display:block!important;text-align:right;flex:0 0 auto!important;overflow:visible;width:auto}
  .row .c-pick{display:none}
  .thead{display:none}
  .thumb{width:3.75rem;height:2.625rem}
  .ph small{display:block;font-size:.6875rem;color:var(--fg3);text-align:right;line-height:1.1;white-space:nowrap;margin-top:.0625rem}
}

@media (prefers-reduced-motion:reduce){
  .sheet,.sheet:not(.show),.scrim,.map .pt,.btn,.map .labs,.track .fill,.track .wh{transition:opacity 120ms ease;transform:none}
  .sheet:not(.show){opacity:0}
  .sheet.show{opacity:1}
  .btn:active,.opt:active,.seg a:active,.seg button:active{transform:none}
}
@media (prefers-reduced-transparency:reduce){
  :root{--glass:var(--bg)}
  .bar,.ihead,.topnav{-webkit-backdrop-filter:none;backdrop-filter:none}
}
@media (prefers-contrast:more){
  :root{--line:var(--line2)}
  .fg3,.mute{color:var(--fg2)}
}
</style>
<body>
<a class="skip" href="#liste">Aller à la liste</a>
<div class="app" id="app">
  <aside class="side">
    <div class="brand"><h1 id="brand"></h1><button class="icobtn m-only" data-act="about" aria-label="À propos des données"><svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 11v5.5M12 7.6v.2"/></svg></button></div>
    <div class="side-scroll">
      <nav class="nav" id="nav" aria-label="Collections"></nav>
      <div id="facets"></div>
    </div>
    <div class="side-foot">
      <button class="foot-btn" data-act="about"><svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 11v5.5M12 7.6v.2"/></svg><span>À propos des données</span></button>
      <button class="foot-btn" data-act="theme"><svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="8.5"/><path d="M12 3.5a8.5 8.5 0 0 1 0 17z" fill="currentColor" stroke="none"/></svg><span class="themelabel">Thème automatique</span></button>
    </div>
  </aside>
  <main class="main" id="main" tabindex="-1">
    <div class="topnav">
      <div class="toprow">
        <div class="search"><svg class="ico" viewBox="0 0 24 24"><circle cx="11" cy="11" r="6.5"/><path d="m16 16 4.5 4.5"/></svg><input id="q2" type="search" placeholder="Rechercher" aria-label="Rechercher" autocomplete="off" spellcheck="false" enterkeyhint="search"><button data-act="clearq" aria-label="Effacer" hidden><svg class="ico" viewBox="0 0 24 24"><path d="m7 7 10 10M17 7 7 17"/></svg></button></div>
        <button class="btn" id="fbtn" data-act="filters"><svg class="ico" viewBox="0 0 24 24"><path d="M4 7h16M7.5 12h9M10.5 17h3"/></svg><span>Filtres</span></button>
      </div>
      <nav class="tabs" id="tabs" aria-label="Collections"></nav>
    </div>
    <div id="view"></div>
    <div class="tray off" id="tray"></div>
  </main>
  <section class="sheet insp" id="insp" role="dialog" aria-label="Fiche" tabindex="-1"></section>
</div>
<div class="scrim for-insp" id="scrim"></div>
<section class="sheet side-sheet" id="fsheet" role="dialog" aria-modal="true" aria-label="Filtres" tabindex="-1"></section>
<section class="sheet side-sheet" id="asheet" role="dialog" aria-modal="true" aria-label="À propos des données" tabindex="-1"></section>
<div class="gtip" id="gtip" role="tooltip" hidden></div>
<script type="application/json" id="atlas-config">/*__CONFIG__*/null</script>
<script type="application/json" id="atlas-data">/*__DATA__*/null</script>
<script type="application/json" id="atlas-images">/*__IMAGES__*/{}</script>
<script type="application/json" id="atlas-logos">/*__LOGOS__*/{}</script>
<script>
"use strict";
const CFG = JSON.parse(document.getElementById("atlas-config").textContent);
const RAW = JSON.parse(document.getElementById("atlas-data").textContent);
const IMG = JSON.parse(document.getElementById("atlas-images").textContent);
const LOGO = JSON.parse(document.getElementById("atlas-logos").textContent);
const $ = s => document.querySelector(s);
const esc = s => String(s ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const norm = s => String(s ?? "").normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();
const slug = s => norm(s).replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "").replace(/-{2,}/g, "-") || "x";
const get = (o, p) => { if (!p) return o; let c = o; for (const k of p.split(".")) { if (c == null) return undefined; c = c[k]; } return c; };
const known = v => v !== null && v !== undefined && v !== "" && !(Array.isArray(v) && !v.length);
const truthy = v => Array.isArray(v) ? v.length > 0 : typeof v === "number" ? v > 0 : !!v && v !== "non";
const ICO = {
  x: '<svg class="ico" viewBox="0 0 24 24"><path d="m7 7 10 10M17 7 7 17"/></svg>',
  plus: '<svg class="ico" viewBox="0 0 24 24"><path d="M12 6v12M6 12h12"/></svg>',
  check: '<svg class="ico" viewBox="0 0 24 24"><path d="m6 12.5 4 4 8-9"/></svg>',
  chev: '<svg class="ico" viewBox="0 0 24 24"><path d="m7 9.5 5 5 5-5"/></svg>',
  up: '<svg class="ico" style="width:.75em;height:.75em" viewBox="0 0 24 24"><path d="m7 14.5 5-5 5 5"/></svg>',
  down: '<svg class="ico" style="width:.75em;height:.75em" viewBox="0 0 24 24"><path d="m7 9.5 5 5 5-5"/></svg>',
  link: '<svg class="ico" viewBox="0 0 24 24"><path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1"/><path d="M14 10a4 4 0 0 0-5.7 0l-3 3A4 4 0 0 0 11 18.7l1-1"/></svg>',
  ext: '<svg class="ico" viewBox="0 0 24 24"><path d="M9 6h9v9M18 6 7 17"/></svg>',
  map: '<svg class="ico" viewBox="0 0 24 24"><path d="M4 4v16h16"/><circle cx="9" cy="14" r="1.2"/><circle cx="13" cy="9" r="1.2"/><circle cx="17.5" cy="12" r="1.2"/></svg>',
  list: '<svg class="ico" viewBox="0 0 24 24"><path d="M5 7h14M5 12h14M5 17h14"/></svg>',
  search: '<svg class="ico" viewBox="0 0 24 24"><circle cx="11" cy="11" r="6.5"/><path d="m16 16 4.5 4.5"/></svg>',
  video: '<svg class="ico" viewBox="0 0 24 24"><rect x="3.5" y="5.5" width="17" height="13" rx="2.5"/><path d="m10.25 9.25 4.5 2.75-4.5 2.75z"/></svg>',
  image: '<svg class="ico" viewBox="0 0 24 24"><rect x="3.5" y="5" width="17" height="14" rx="2.5"/><circle cx="8.75" cy="9.75" r="1.4"/><path d="m4 16.5 4.5-3.75 3.25 2.5 3.5-3.75 4.75 4.75"/></svg>',
  audio: '<svg class="ico" viewBox="0 0 24 24"><path d="M4 10.5v3M8 7.5v9M12 4.5v15M16 8v8M20 10.5v3"/></svg>',
  cube: '<svg class="ico" viewBox="0 0 24 24"><path d="M12 3.25 19.75 7.6v8.8L12 20.75 4.25 16.4V7.6z"/><path d="M4.25 7.6 12 12l7.75-4.4M12 12v8.75"/></svg>',
  open: '<svg class="ico" viewBox="0 0 24 24"><rect x="5" y="10.5" width="14" height="9.5" rx="2.25"/><path d="M8 10.5V7.75a4 4 0 0 1 7.6-1.75"/></svg>',
  lock: '<svg class="ico" viewBox="0 0 24 24"><rect x="5" y="10.5" width="14" height="9.5" rx="2.25"/><path d="M8 10.5V8a4 4 0 0 1 8 0v2.5"/></svg>',
  laptop: '<svg class="ico" viewBox="0 0 24 24"><rect x="5" y="5.5" width="14" height="10" rx="1.75"/><path d="M2.75 18.75h18.5"/></svg>',
  cloud: '<svg class="ico" viewBox="0 0 24 24"><path d="M7.25 18.5a4.25 4.25 0 0 1-.55-8.46 5.5 5.5 0 0 1 10.6-.74 4.65 4.65 0 0 1 .05 9.2z"/></svg>',
  licence: '<svg class="ico" viewBox="0 0 24 24"><path d="M7 3.75h7l4 4V20.25H7z"/><path d="M14 3.75v4h4M10 12h5M10 15.5h5"/></svg>',
  plug: '<svg class="ico" viewBox="0 0 24 24"><path d="M9 3.5v5M15 3.5v5M6.5 8.5h11v2.75a5.5 5.5 0 0 1-11 0zM12 16.75v3.75"/></svg>',
  eye: '<svg class="ico" viewBox="0 0 24 24"><path d="M2.75 12S6.25 5.75 12 5.75 21.25 12 21.25 12 17.75 18.25 12 18.25 2.75 12 2.75 12z"/><circle cx="12" cy="12" r="2.75"/></svg>',
  tag: '<svg class="ico" viewBox="0 0 24 24"><path d="M4 4.75h7.5l8.25 8.25-6.75 6.75L4.75 11.5z"/><circle cx="8.5" cy="9" r="1.1"/></svg>',
  top: '<svg class="ico" viewBox="0 0 24 24"><path d="M5 19.5v-6.5M12 19.5v-15M19 19.5v-10"/></svg>',
  matrix: '<svg class="ico" viewBox="0 0 24 24"><rect x="4" y="4" width="4.5" height="4.5" rx="1"/><rect x="9.75" y="4" width="4.5" height="4.5" rx="1"/><rect x="15.5" y="4" width="4.5" height="4.5" rx="1"/><rect x="4" y="9.75" width="4.5" height="4.5" rx="1"/><rect x="9.75" y="9.75" width="4.5" height="4.5" rx="1"/><rect x="15.5" y="9.75" width="4.5" height="4.5" rx="1"/><rect x="4" y="15.5" width="4.5" height="4.5" rx="1"/><rect x="9.75" y="15.5" width="4.5" height="4.5" rx="1"/><rect x="15.5" y="15.5" width="4.5" height="4.5" rx="1"/></svg>',
  layers: '<svg class="ico" viewBox="0 0 24 24"><path d="m12 4 8.25 4.5L12 13 3.75 8.5z"/><path d="m3.75 12.25 8.25 4.5 8.25-4.5M3.75 16 12 20.5l8.25-4.5"/></svg>',
  chip: '<svg class="ico" viewBox="0 0 24 24"><rect x="6.5" y="6.5" width="11" height="11" rx="1.75"/><path d="M9.5 3.5v3M14.5 3.5v3M9.5 17.5v3M14.5 17.5v3M3.5 9.5h3M3.5 14.5h3M17.5 9.5h3M17.5 14.5h3"/></svg>',
  window: '<svg class="ico" viewBox="0 0 24 24"><rect x="3.5" y="5" width="17" height="14" rx="2.5"/><path d="M3.5 9.25h17M6.5 7.1h.1M9 7.1h.1"/></svg>',
  clock: '<svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="8.25"/><path d="M12 7.5V12l3 2"/></svg>',
  person: '<svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="8.25" r="3.5"/><path d="M5 20c.75-3.75 3.5-5.5 7-5.5s6.25 1.75 7 5.5"/></svg>',
  globe: '<svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="8.25"/><path d="M3.75 12h16.5M12 3.75c2.5 2.5 3.5 5.25 3.5 8.25s-1 5.75-3.5 8.25c-2.5-2.5-3.5-5.25-3.5-8.25s1-5.75 3.5-8.25z"/></svg>',
  input: '<svg class="ico" viewBox="0 0 24 24"><path d="M12 4v10M8 10.5l4 4 4-4M5 19.5h14"/></svg>',
  output: '<svg class="ico" viewBox="0 0 24 24"><path d="M12 15V5M8 8.5l4-4 4 4M5 19.5h14"/></svg>',
  status: '<svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="8.25"/><path d="m8.25 12.25 2.5 2.5 5-5.25"/></svg>',
  stage: '<svg class="ico" viewBox="0 0 24 24"><path d="M4 6.5h16M4 12h10M4 17.5h6"/></svg>',
  tools: '<svg class="ico" viewBox="0 0 24 24"><path d="M14.5 6.25a4 4 0 0 1 5-1.25l-2.75 2.75 1.5 1.5L21 6.5a4 4 0 0 1-5.5 4.75L8 18.75a1.75 1.75 0 0 1-2.5-2.5z"/></svg>',
  face: '<svg class="ico" viewBox="0 0 24 24"><circle cx="12" cy="12" r="8.25"/><path d="M9 10v.25M15 10v.25M8.75 14.5c1.75 1.75 4.75 1.75 6.5 0"/></svg>',
  shape: '<svg class="ico" viewBox="0 0 24 24"><circle cx="8" cy="8" r="4"/><rect x="11.5" y="11.5" width="8.5" height="8.5" rx="1.5"/></svg>'
};
const ico = n => ICO[n] || "";
const WORD = { y: "oui", p: "partiel", n: "non", u: "non vérifié" };
function tri(v) {
  if (v === true) return "y"; if (v === false) return "n"; if (v == null || v === "") return "u";
  if (typeof v === "number") return v > 0 ? "y" : "n";
  const s = norm(v);
  if (/^(non verifi|non vu|non releve|non lu|inconnu|voir|\?|non applicable)/.test(s)) return "u";
  if (/^(partiel|oui partiel|oui mais|oui pour|oui, tard|via )/.test(s)) return "p";
  if (/^oui/.test(s)) return "y";
  if (/^non/.test(s)) return "n";
  return "u";
}
function flagState(b, it) {
  const v = get(it.view, b.path);
  if (b.classes) { const s = String(v ?? ""); for (const k of b.classes) if (new RegExp(k.re, "i").test(s)) return k.state; return b.else || "n"; }
  if (b.eq !== undefined) return v === b.eq ? "y" : tri(v) === "y" ? "p" : tri(v);
  return tri(v);
}
function flagsHtml(items, it) {
  return `<span class="flags">${items.map(b => {
    const st = flagState(b, it), v = get(it.view, b.path);
    const detail = typeof v === "string" && v.length > 3 ? v : WORD[st];
    const tip = `${b.label} : ${detail}`;
    return `<span class="fl ${st}" role="img" aria-label="${esc(b.label)} : ${esc(WORD[st])}" data-tip="${esc(tip)}">${ico(b.icon)}</span>`;
  }).join("")}</span>`;
}
function logoHtml(it) {
  const l = cfgOf(it.col)?.logo; if (!l) return "";
  const v = get(it.raw, l.path); let k = null;
  if (l.rules) { for (const r of l.rules) if (new RegExp(r.re, "i").test(String(v ?? ""))) { k = r.host; break; } }
  else if (v) k = host(v);
  if (k && LOGO[k]) return `<span class="lg"><img alt="" src="${LOGO[k]}"></span>`;
  const base = String((l.rules ? v : null) || it.title).replace(/[^\p{L}\p{N} ]/gu, " ").trim().split(/\s+/);
  const mono = base.length > 1 && !l.oneLetter ? base[0][0] + base[1][0] : (base[0] || "?").slice(0, 2);
  return `<span class="lg mono" aria-hidden="true">${esc(mono.toUpperCase().slice(0, 2))}</span>`;
}
function heatLegend() { return `<span class="hleg"><span>Note de 0 à 3</span>${[0, 1, 2, 3].map(v => `<span class="heat"><i class="v${v}">${v}</i></span>`).join("")}<span><span class="heat"><i class="vn"></i></span>non évalué, différent de 0</span></span>`; }
const FR = CFG.lang || "fr";
const fmtNum = (v, d) => new Intl.NumberFormat(FR, { maximumFractionDigits: d ?? 2 }).format(v);
const dict = (name, v) => (CFG.dicts?.[name]?.[v]) ?? v;
const parseDate = s => { const m = /^(\d{4})-(\d{2})(?:-(\d{2}))?/.exec(s || ""); return m ? new Date(+m[1], +m[2] - 1, +(m[3] || 1)) : null; };
const fmtDate = s => { const m = /^(\d{4})-(\d{2})(?:-(\d{2}))?/.exec(String(s)); return m ? (m[3] ? `${m[3]}/${m[2]}/${m[1]}` : `${m[2]}/${m[1]}`) : String(s); };
const daysSince = s => { const d = parseDate(s); return d ? Math.floor((Date.now() - d) / 864e5) : null; };
const ageWords = n => n == null ? "" : n <= 0 ? "aujourd'hui" : n === 1 ? "hier" : n < 60 ? `il y a ${n} jours` : `il y a ${Math.round(n / 30)} mois`;
const usd = v => { const a = Math.abs(v); return fmtNum(v, a >= 100 ? 0 : a >= 1 ? 2 : a >= .1 ? 3 : 4) + " $"; };
const stripParens = s => String(s || "").replace(/\s*\([^)]*\)\s*/g, " ").trim();
const host = u => { try { return new URL(u).hostname.replace(/^www\./, ""); } catch { return u; } };
const safeUrl = u => /^https?:\/\//i.test(u || "") ? u : null;
const img = p => IMG[p] || p;

/* Données : chaque élément garde son objet source intact dans .raw */
const COLS = {}, ORDER = [], RAWITEM = new WeakMap();
function hydrate() {
  for (const c of CFG.collections) {
    const list = get(RAW, c.path) || [];
    const derived = c.derived ? (get(RAW, c.derived) || {}) : {};
    const joins = (c.joins || []).map(j => {
      if (j.many) {
        const alias = j.alias ? (get(RAW, j.alias) || {}) : {};
        const m = {};
        for (const r of get(RAW, j.from) || []) { const k = alias[r[j.key]] ?? r[j.key]; (m[k] ||= []).push(r); }
        return { as: j.as, map: m };
      }
      return { as: j.as, map: get(RAW, j.from) || {} };
    });
    const used = new Set();
    const items = list.map((raw, i) => {
      let id = c.idKey ? raw[c.idKey] : null;
      id = id && /^[A-Za-z0-9-]+$/.test(id) && !id.includes("--") ? id : (c.idKey ? slug(raw[c.idKey]) : `${c.idPrefix || "e"}${i + 1}`);
      if (used.has(id)) id = `${id}-${i + 1}`;
      used.add(id);
      const _ = { ...(derived[raw[c.derivedKey || "id"]] || {}), ...{} };
      const j = {};
      for (const x of joins) j[x.as] = x.map[raw[c.idKey || "id"]];
      const view = { ...raw, _, _j: j };
      const tpl = p => { const v = get(view, p); return v == null ? "" : String(v); };
      const subOf = p => { if (typeof p === "string") return tpl(p); const s = tpl(p.path); for (const k of p.classes || []) if (new RegExp(k.re, "i").test(s)) return k.label; return ""; };
      let title = (c.title || []).map(tpl).find(Boolean) || id, sub = (c.subtitle || []).map(subOf).filter(Boolean);
      if (c.titlePrefix) {
        const pre = tpl(c.titlePrefix), words = norm(pre).split(/[\s()]+/).filter(w => w.length > 1), tn = norm(title);
        if (pre && !words.some(w => tn.includes(w))) title = `${pre} ${title}`;
        sub = sub.filter(x => x !== pre);
      }
      if (c.dicts) for (const [i, d] of Object.entries(c.dicts)) if (sub[i] != null) sub[i] = dict(d, sub[i]);
      const item = { id, raw, view, col: c.id, title, sub: sub.join(" · "), _search: null };
      RAWITEM.set(raw, item);
      return item;
    });
    const byId = new Map(items.map(x => [x.id, x]));
    COLS[c.id] = { cfg: c, items, byId };
    ORDER.push(c.id);
  }
}
function valuesOf(o, out) { if (o == null) return out; if (typeof o === "object") { for (const k in o) valuesOf(o[k], out); } else if (typeof o === "string" ? !/^https?:/.test(o) : typeof o === "number") out.push(o); return out; }
const searchText = it => it._search ??= norm(it.title + " " + it.sub + " " + valuesOf(it.raw, []).join(" ") + " " + (it.view._?.stages || []).map(x => dict("stage", x)).join(" "));

/* Etat */
const S = { col: null, view: null, q: "", qn: [], sel: {}, sort: {}, open: null, compare: false, cmp: {}, diffOnly: true, axes: {}, cursor: null, expand: {}, sheet: null, crit: {}, boardAll: {}, min: {} };
const narrow = matchMedia("(max-width:899px)");
const docked = matchMedia("(min-width:1200px)");
const cfgOf = id => COLS[id]?.cfg;
const hasMap = id => !!cfgOf(id)?.map;
const viewsOf = id => cfgOf(id)?.views || (hasMap(id) ? ["map", "list"] : ["list"]);
const VIEWS = { top: "top", matrix: "matrice", map: "carte", list: "liste" }, VIEWNAME = { top: "Top", matrix: "Matrice", map: "Carte", list: "Liste" }, VIEWICO = { top: "top", matrix: "matrix", map: "map", list: "list" };
const isBoardView = v => v === "top" || v === "matrix";
const sel = c => S.sel[c] ||= {};
const facetOf = (c, id) => (cfgOf(c).facets || []).find(f => f.id === id);
const optVal = (f, v) => {
  if (f.classes) { const s = String(v); for (const k of f.classes) if (new RegExp(k.re, "i").test(s)) return k.label; return f.other || null; }
  return f.norm === "firstword" ? norm(String(v).split(/[\s:,(;]/)[0]) : v;
};

function itemVals(f, it) {
  const v = get(it.view, f.path);
  if (!known(v)) return [];
  const arr = Array.isArray(v) ? v : [v];
  return arr.map(x => optVal(f, x)).filter(known).map(String);
}
function testOpt(f, optId, it) {
  if (f.type === "checks") {
    const o = f.items.find(x => x.id === optId);
    if (!o) return false;
    const x = get(it.view, o.path);
    if (o.in) return o.in.includes(x);
    return o.eq !== undefined ? x === o.eq : truthy(x);
  }
  if (f.type === "threshold") { const v = get(it.view, f.path); return typeof v === "number" && v >= +optId; }
  return itemVals(f, it).some(x => slug(x) === optId);
}
function passFacet(f, set, it) {
  if (!set?.size) return true;
  const each = [...set];
  return (f.mode === "and" || f.type === "checks") ? each.every(o => testOpt(f, o, it)) : each.some(o => testOpt(f, o, it));
}
const passQ = it => { if (!S.qn.length) return true; const t = searchText(it); return S.qn.every(w => t.includes(w)); };
function filtered(cid, exceptFacet) {
  const c = COLS[cid], s = sel(cid), fs = c.cfg.facets || [];
  return c.items.filter(it => passQ(it) && fs.every(f => f.id === exceptFacet || passFacet(f, s[f.id], it)));
}
function sortKeys(cid) {
  const c = cfgOf(cid);
  return c.sort || [];
}
function curSort(cid) {
  const c = cfgOf(cid), keys = sortKeys(cid);
  const st = S.sort[cid];
  if (st) return st;
  const d = keys.find(k => k.id === c.defaultSort) || keys[0];
  return { id: d?.id, dir: d?.dir || "asc" };
}
function sorted(cid, items) {
  const st = curSort(cid), k = sortKeys(cid).find(x => x.id === st.id);
  const dir = st.dir === "desc" ? -1 : 1;
  const coll = new Intl.Collator(FR, { sensitivity: "base", numeric: true });
  const out = items.slice();
  if (k) out.sort((a, b) => {
    const va = get(a.view, k.path), vb = get(b.view, k.path);
    const ka = known(va), kb = known(vb);
    if (ka !== kb) return ka ? -1 : 1;
    if (!ka) return coll.compare(a.title, b.title);
    if (typeof va === "number" && typeof vb === "number") return (va - vb) * dir || coll.compare(a.title, b.title);
    return coll.compare(String(va), String(vb)) * dir || coll.compare(a.title, b.title);
  });
  if (S.qn.length) { const q = S.qn.join(" "); const tq = it => norm(it.title).includes(q) ? 0 : norm(it.sub).includes(q) ? 1 : 2; return out.map((x, i) => [x, i]).sort((a, b) => tq(a[0]) - tq(b[0]) || a[1] - b[1]).map(x => x[0]); }
  return out;
}

/* Formats */
function renderSources(L) {
  const arr = Array.isArray(L) ? L : [L];
  const TYPES = CFG.dicts?.source_type || {};
  return `<ul class="srcs">${arr.map(s => {
    if (typeof s === "string") return safeUrl(s) ? `<li><a href="${esc(s)}" target="_blank" rel="noopener">${esc(host(s))}</a></li>` : `<li>${esc(s)}</li>`;
    const u = safeUrl(s.url);
    const tail = [s.date && fmtDate(s.date), s.type && (TYPES[s.type] || s.type)].filter(Boolean).join(" · ");
    return `<li>${u ? `<a href="${esc(u)}" target="_blank" rel="noopener">${esc(host(u))}</a>` : esc(s.label || s.ref || "sans lien")}${tail ? `<small>${esc(tail)}</small>` : ""}</li>`;
  }).join("")}</ul>`;
}
const labelFor = (k, p) => CFG.fieldLabels?.[p] ?? CFG.fieldLabels?.[k] ?? k.replace(/_/g, " ").replace(/^./, c => c.toUpperCase());
function autoVal(v, path) {
  if (!known(v)) return '<span class="q">?</span>';
  if (typeof v === "boolean") return v ? "Oui" : "Non";
  if (typeof v === "number") return esc(fmtNum(v, 4));
  if (typeof v === "string") {
    if (safeUrl(v)) return `<a class="tlink" href="${esc(v)}" target="_blank" rel="noopener">${esc(host(v))}</a>`;
    if (/^\d{4}-\d{2}(-\d{2})?$/.test(v)) return esc(fmtDate(v));
    return esc(v);
  }
  if (Array.isArray(v)) {
    if (v.every(x => typeof x !== "object")) return esc(v.join(", "));
    if (v[0] && v[0].url !== undefined && (v[0].date !== undefined || v[0].type !== undefined)) return renderSources(v);
    return `<ul class="ul recs">${v.map(x => `<li>${typeof x === "object" ? autoVal(x, path) : esc(x)}</li>`).join("")}</ul>`;
  }
  const rows = Object.entries(v).filter(([, x]) => known(x));
  if (!rows.length) return '<span class="q">?</span>';
  return `<dl class="fields">${rows.map(([k, x]) => `<dt>${esc(labelFor(k, path ? path + "." + k : k))}</dt><dd>${k === "sources" ? renderSources(x) : autoVal(x, path ? path + "." + k : k)}</dd>`).join("")}</dl>`;
}
function fmtVal(f, it, ctx) {
  const v = f.path ? get(it.view, f.path) : undefined;
  const fm = f.fmt || "text";
  if (fm === "badges") {
    const parts = f.items.map(b => {
      const x = get(it.view, b.path);
      if (!truthy(x)) return "";
      return `<span class="badge">${b.count && typeof x === "number" ? `${esc(fmtNum(x, 0))} ` : ""}${esc(b.label)}</span>`;
    }).filter(Boolean);
    return parts.length ? parts.join("") : f.items.some(b => known(get(it.view, b.path))) ? '<span class="mute">Non</span>' : '<span class="q">?</span>';
  }
  if (fm === "heat") return heatHtml(f.items.map(p => get(it.view, p)), f.titles, f.items.map(p => get(it.view, p.replace(/\.note$/, ".justification"))));
  if (fm === "flags") return flagsHtml(f.items, it);
  if (fm === "promotions") {
    if (!known(v)) return '<span class="q">?</span>';
    return `<ul class="ul">${(Array.isArray(v) ? v : [v]).map(x => {
      if (typeof x !== "object") return `<li>${esc(x)}</li>`;
      const past = x.ends && daysSince(x.ends) > 0;
      return `<li>${esc(x.text ?? JSON.stringify(x))}${x.ends ? ` <span class="${past ? "expired" : "mute"}">${past ? "expirée le " : "jusqu'au "}${esc(fmtDate(x.ends))}</span>` : ""}${x.source ? ` ${renderSrcInline(x.source)}` : ""}</li>`;
    }).join("")}</ul>`;
  }
  if (fm === "grille") {
    const n = v && v.note;
    return `<div class="scorerow">${heatHtml([n])}<span>${known(n) ? esc(n) + " / 3" : '<span class="mute">non évalué</span>'}${v && v.justification && norm(v.justification) !== "non evalue" ? ` <span class="mute">${esc(v.justification)}</span>` : ""}</span></div>`;
  }
  if (fm === "table") {
    let rows = Array.isArray(v) ? v.slice() : [];
    if (!rows.length) return '<span class="q">?</span>';
    if (f.sortBy) rows.sort((a, b) => { for (const p of f.sortBy) { const x = get(a, p), y = get(b, p); if (known(x) !== known(y)) return known(x) ? -1 : 1; if (known(x) && x !== y) return x < y ? -1 : 1; } return 0; });
    return tableHtml(rows, f.cols);
  }
  if (fm === "dicttable") {
    if (!v || !Object.keys(v).length) return '<span class="q">?</span>';
    const rows = Object.entries(v).map(([k, x]) => ({ _k: dict(f.keyDict, k), ...(typeof x === "object" ? x : { value: x }) }));
    return tableHtml(rows, f.cols);
  }
  if (!known(v)) return '<span class="q">?</span>';
  switch (fm) {
    case "itemlink": { const t = RAWITEM.get(it.view); return t ? `<a class="tlink" href="#f-${t.col}-${esc(t.id)}">${esc(v)}</a>` : esc(v); }
    case "bool": return v === true ? "Oui" : v === false ? '<span class="mute">Non</span>' : esc(v);
    case "num": return esc(typeof v === "number" ? fmtNum(v, f.d ?? 2) + (f.unit ? " " + f.unit : "") : v);
    case "usd": return typeof v === "number" ? esc(usd(v)) : esc(v);
    case "date": return esc(fmtDate(v));
    case "dict": return esc(dict(f.dict, v));
    case "sentence": return esc(String(v).replace(/^./, x => x.toUpperCase()));
    case "tag": { const t = CFG.tones?.[f.dict]?.[v]; return `<span class="tag ${t || ""}">${esc(dict(f.dict, v))}</span>`; }
    case "list": return esc((Array.isArray(v) ? v : [v]).map(x => f.dict ? dict(f.dict, x) : (typeof x === "object" ? JSON.stringify(x) : x)).join(", "));
    case "bullets": return `<ul class="ul">${(Array.isArray(v) ? v : [v]).map(x => `<li>${esc(typeof x === "object" ? JSON.stringify(x) : x)}</li>`).join("")}</ul>`;
    case "sources": return renderSources(v);
    case "url": return safeUrl(v) ? `<a class="tlink" href="${esc(v)}" target="_blank" rel="noopener">${esc(host(v))}</a>` : esc(v);
    case "ref": {
      const id = (f.alias ? get(RAW, f.alias)?.[v] : null) ?? v;
      const cid = (f.cols || []).find(x => COLS[x]?.byId.has(id));
      return cid ? `<a class="tlink" href="#f-${cid}-${esc(id)}">${esc(COLS[cid].byId.get(id).title)}</a>` : `${esc(v)} <span class="mute">(pas de fiche)</span>`;
    }
    case "auto": return autoVal(v, f.path);
    default: return typeof v === "object" ? autoVal(v, f.path) : esc(v);
  }
}
function renderSrcInline(s) { return Array.isArray(s) || typeof s === "object" ? renderSources(s) : (safeUrl(s) ? `<a class="tlink" href="${esc(s)}" target="_blank" rel="noopener">source</a>` : ""); }
function heatTip(title, v, just) { return `${title ? title + " : " : ""}${known(v) ? v + " sur 3" : "non évalué"}${known(v) && just ? ". " + just : ""}`; }
function heatHtml(vals, titles, justs) { return `<span class="heat" role="img" aria-label="${esc(vals.map((v, i) => `${titles?.[i] ? titles[i] + " " : ""}${known(v) ? v : "non évalué"}`).join(", "))}">${vals.map((v, i) => `<i class="${known(v) ? "v" + v : "vn"}"${titles?.[i] ? ` data-tip="${esc(heatTip(titles[i], v, justs?.[i]))}"` : ""}>${known(v) ? esc(v) : ""}</i>`).join("")}</span>`; }
function tableHtml(rows, cols) {
  const fakeIt = r => ({ view: r });
  return `<div class="tw"><table class="t"><thead><tr>${cols.map(c => `<th class="${c.fmt === "usd" || c.fmt === "num" ? "n" : ""}">${esc(c.label)}</th>`).join("")}</tr></thead><tbody>${rows.map(r => `<tr>${cols.map(c => `<td class="${c.fmt === "usd" || c.fmt === "num" ? "n" : ""}">${known(get(r, c.path)) ? fmtVal(c, fakeIt(r)) : '<span class="q">?</span>'}</td>`).join("")}</tr>`).join("")}</tbody></table></div>`;
}

/* Hachage : uniquement des lettres, chiffres et tirets, pour rester valable dans un cadre isolé */
function viewHash() {
  const parts = [`v-${S.col}-${VIEWS[S.view] || "liste"}`];
  if (isBoardView(S.view) && S.crit[S.col]) parts.push(`t-${S.crit[S.col]}`);
  const s = sel(S.col);
  for (const [f, set] of Object.entries(s)) for (const o of set) parts.push(`s-${f}-${o}`);
  if (S.q.trim()) parts.push(`q-${slug(S.q)}`);
  return parts.join("--");
}
let memHash = null, curHash = "";
function setHash(h, replace) {
  if (curHash === h) return;
  const silent = replace && h.startsWith("v-");
  try { replace ? location.replace("#" + h) : (location.hash = h); } catch {}
  // Si le cadre refuse le hachage, la navigation continue en mémoire.
  if (location.hash.slice(1) !== h) { memHash = h; if (silent) curHash = h; else route(); }
}
function defaultView(col) { const v = viewsOf(col); return v[0] === "map" && narrow.matches ? "list" : v[0]; }
function route() {
  const h = memHash ?? location.hash.slice(1);
  memHash = null; curHash = h;
  S.open = null; S.compare = false; S.sheet = S.sheet === "filters" ? "filters" : null;
  if (h === "a-propos") { S.sheet = "about"; if (!S.col) { S.col = CFG.defaultCollection; S.view = defaultView(S.col); } }
  else if (h.startsWith("f-")) {
    const m = /^f-([a-z0-9]+)-(.+)$/.exec(h);
    if (m && COLS[m[1]]?.byId.has(m[2])) { if (S.col !== m[1]) { S.col = m[1]; S.view = S.view || defaultView(m[1]); } S.open = { col: m[1], id: m[2] }; S.cursor = m[2]; }
  } else if (h.startsWith("c-")) {
    const p = h.slice(2).split("--"), col = p.shift();
    if (COLS[col]) { S.col = col; S.view = S.view || defaultView(col); S.cmp[col] = p.filter(x => COLS[col].byId.has(x)).slice(0, 6); S.compare = true; }
  } else if (h.startsWith("v-")) {
    const toks = h.split("--"), m = /^v-([a-z0-9]+)(?:-(carte|liste|top|matrice))?$/.exec(toks[0]);
    if (m && COLS[m[1]]) {
      if (S.col !== m[1]) { /* changer de collection garde les filtres de chacune */ }
      S.col = m[1]; S.view = Object.keys(VIEWS).find(k => VIEWS[k] === m[2]) || defaultView(m[1]);
      for (const t of toks.slice(1)) if (t.startsWith("t-")) S.crit[S.col] = t.slice(2);
      if (toks.length > 1) {
        const nextSel = {}; let q = null;
        for (const t of toks.slice(1)) {
          if (t.startsWith("q-")) q = t.slice(2).replace(/-/g, " ");
          else if (t.startsWith("s-")) { const mm = /^s-([a-z0-9]+)-(.+)$/.exec(t); if (mm && facetOf(S.col, mm[1])) (nextSel[mm[1]] ||= new Set()).add(mm[2]); }
        }
        S.sel[S.col] = nextSel;
        if (q != null && norm(q) !== S.qn.join(" ")) setQuery(q);
      }
    }
  }
  if (!S.col) { S.col = CFG.defaultCollection; S.view = defaultView(S.col); }
  if (!S.view || !viewsOf(S.col).includes(S.view)) S.view = defaultView(S.col);
  render();
}
function setQuery(q) {
  S.q = q; S.qn = norm(q).trim().split(/\s+/).filter(Boolean);
  for (const el of [$("#q1"), $("#q2")]) if (el && el.value !== q) el.value = q;
  for (const b of document.querySelectorAll('[data-act="clearq"]')) b.hidden = !q;
  for (const k of document.querySelectorAll(".search kbd")) k.hidden = !!q;
}

/* Rendu général */
let listKey = "", mapKey = "", rowsCache = [], shown = 0, mode = "";
function render() {
  document.body.classList.toggle("locked", narrow.matches && !!(S.open || S.sheet));
  renderNav();
  renderFacets();
  renderMain();
  renderInspector();
  renderTray();
  renderSheets();
}
function navCounts() {
  return ORDER.map(id => [id, S.qn.length ? COLS[id].items.filter(passQ).length : COLS[id].items.length]);
}
function renderNav() {
  $("#nav").hidden = $("#tabs").hidden = ORDER.length < 2;
  const counts = navCounts();
  const a = counts.map(([id, n]) => {
    const c = cfgOf(id), cur = id === S.col;
    return `<a href="#v-${id}" ${cur ? 'aria-current="page"' : ""} class="${S.qn.length && !n ? "dim" : ""}"><span class="l">${ico(c.icon)}${esc(c.label)}</span><span class="n">${esc(fmtNum(n, 0))}</span></a>`;
  }).join("");
  $("#nav").innerHTML = a;
  $("#tabs").innerHTML = a;
  const cur = $("#tabs [aria-current]");
  if (cur && cur.scrollIntoView && $("#tabs").scrollWidth > $("#tabs").clientWidth) { const t = $("#tabs"); const r = cur.offsetLeft - (t.clientWidth - cur.offsetWidth) / 2; t.scrollLeft = Math.max(0, r); }
}
function facetsHtml(cid) {
  const c = cfgOf(cid), s = sel(cid);
  return (c.facets || []).map(f => {
    const base = filtered(cid, f.id);
    let opts;
    if (f.type === "checks") opts = f.items.map(o => ({ id: o.id, label: o.label, icon: o.icon, n: base.filter(it => testOpt(f, o.id, it)).length }));
    else if (f.type === "threshold") opts = f.steps.map(v => ({ id: String(v), label: `${f.prefix || "≥"} ${fmtNum(v, 0)}${f.unit ? " " + f.unit : ""}`, n: base.filter(it => testOpt(f, String(v), it)).length }));
    else {
      const counts = new Map();
      for (const it of base) for (const v of new Set(itemVals(f, it))) counts.set(v, (counts.get(v) || 0) + 1);
      opts = [...counts.entries()].map(([v, n]) => ({ id: slug(v), label: f.dict ? dict(f.dict, v) : (f.norm === "firstword" ? v[0].toUpperCase() + v.slice(1) : v), n }));
      if (f.classes) { const rank = l => f.classes.findIndex(k => k.label === l); opts.sort((a, b) => (f.labelOrder ? f.labelOrder.indexOf(a.label) - f.labelOrder.indexOf(b.label) : rank(a.label) - rank(b.label))); }
      else opts.sort((a, b) => f.order === "alpha" ? a.label.localeCompare(b.label, FR) : b.n - a.n || a.label.localeCompare(b.label, FR));
    }
    const on = s[f.id] || new Set();
    opts = opts.filter(o => o.n > 0 || on.has(o.id));
    if (!opts.length) return "";
    const lim = f.limit || 8, key = cid + f.id, open = S.expand[key];
    const vis = open ? opts : opts.filter((o, i) => i < lim || on.has(o.id));
    return `<div class="fgroup"><h3>${ico(f.icon)}${esc(f.label)}</h3>${vis.map(o => `<button class="opt" data-f="${esc(f.id)}" data-o="${esc(o.id)}" aria-pressed="${on.has(o.id)}"><span class="l">${ico(o.icon)}${esc(o.label)}</span><span class="n">${esc(fmtNum(o.n, 0))}</span></button>`).join("")}${opts.length > vis.length ? `<button class="more" data-more="${esc(key)}">Afficher tout (${opts.length})</button>` : (open && opts.length > lim ? `<button class="more" data-more="${esc(key)}">Réduire</button>` : "")}</div>`;
  }).join("");
}
function renderFacets() { if (!narrow.matches) { const st = $(".side-scroll").scrollTop; $("#facets").innerHTML = facetsHtml(S.col); $(".side-scroll").scrollTop = st; } }
function activeChips() {
  const s = sel(S.col), out = [];
  for (const [fid, set] of Object.entries(s)) {
    const f = facetOf(S.col, fid); if (!f) continue;
    for (const o of set) {
      let label = o;
      if (f.type === "checks") label = f.items.find(x => x.id === o)?.label || o;
      else if (f.type === "threshold") label = `${f.label} ${f.prefix || "≥"} ${o}${f.unit ? " " + f.unit : ""}`;
      else { const v = COLS[S.col].items.flatMap(it => itemVals(f, it)).find(x => slug(x) === o); label = v ? (f.dict ? dict(f.dict, v) : v) : o; if (f.classes) label = `${f.label} : ${String(label).toLowerCase()}`; }
      out.push(`<button class="chip" data-f="${esc(fid)}" data-o="${esc(o)}" aria-pressed="true" aria-label="Retirer le filtre ${esc(label)}">${esc(label)}${ICO.x}</button>`);
    }
  }
  return out;
}
function freshLine() {
  const d = CFG.dataDate, n = daysSince(d);
  if (!d) return "";
  const old = n != null && n > (CFG.staleAfterDays ?? 14);
  return `<div class="fresh${old ? " old" : ""}">${old ? ico("clock") : ""}<span>${old ? "Données anciennes : relevé" : "Relevé"} du ${esc(fmtDate(d))}, ${esc(ageWords(n))}.</span>${old && CFG.staleNote ? `<b>${esc(CFG.staleNote)}</b>` : ""}</div>`;
}
function renderMain() {
  const v = $("#view");
  if (S.compare) { mode = "cmp"; listKey = mapKey = ""; v.innerHTML = compareHtml(); return; }
  const c = cfgOf(S.col);
  const key = JSON.stringify([S.col, S.view, S.qn, Object.entries(sel(S.col)).map(([a, b]) => [a, [...b]]), curSort(S.col)]);
  const items = filtered(S.col);
  $("#fbtn").querySelector("span").textContent = Object.values(sel(S.col)).reduce((a, b) => a + b.size, 0) ? `Filtres (${Object.values(sel(S.col)).reduce((a, b) => a + b.size, 0)})` : "Filtres";
  if (mode !== S.col + S.view) {
    mode = S.col + S.view; listKey = ""; mapKey = "";
    v.innerHTML = `<div class="bar" id="bar"></div><div id="meta"></div><div id="boardslot"></div><div id="mapslot"></div><div class="list" id="liste"></div>`;
  }
  const noun = items.length > 1 ? (c.nounPlural || c.label) : (c.noun || c.label);
  const st = curSort(S.col);
  const qVal = esc(S.q);
  if (!$("#q1")) {
    $("#bar").innerHTML = `<h2 class="count" id="count" aria-live="polite"></h2>
      <div class="search d-only">${ICO.search}<input id="q1" type="search" placeholder="Rechercher" aria-label="Rechercher" autocomplete="off" spellcheck="false" value="${qVal}"><kbd ${S.q ? "hidden" : ""}>/</kbd><button data-act="clearq" aria-label="Effacer" ${S.q ? "" : "hidden"}>${ICO.x}</button></div>
      <div class="seg" id="seg"></div><label class="selectwrap right-sp" id="sortwrap"></label>`;
  }
  $("#count").textContent = S.view === "top" ? (c.board?.title || "Top") : S.view === "matrix" ? "Outils par critère" : `${fmtNum(items.length, 0)} ${noun}`;
  const vs = viewsOf(S.col);
  $("#seg").hidden = vs.length < 2;
  if (vs.length > 1) $("#seg").innerHTML = vs.map(x => `<a href="#v-${S.col}-${VIEWS[x]}" aria-current="${S.view === x}">${ico(VIEWICO[x])}<span>${VIEWNAME[x]}</span></a>`).join("");
  $("#sortwrap").hidden = isBoardView(S.view);
  $("#sortwrap").innerHTML = `<span>Trier</span><select id="sortsel" aria-label="Trier par">${sortKeys(S.col).map(k => `<option value="${esc(k.id)}" ${k.id === st.id ? "selected" : ""}>${esc(k.label)}</option>`).join("")}</select>${ICO.chev}`;
  const chips = activeChips();
  $("#meta").innerHTML = (chips.length ? `<div class="chips">${chips.join("")}<button class="tlink" style="font-size:.75rem;padding:0 .25rem" data-act="clearf">Tout effacer</button></div>` : "") + freshLine();
  const changed = key !== listKey && !!listKey;
  if (isBoardView(S.view)) {
    listKey = "";
    $("#liste").innerHTML = ""; $("#liste").hidden = true; $("#mapslot").innerHTML = ""; mapKey = "";
    if (S.view === "top") renderBoard(items); else renderMatrix(items);
    markRows(); syncBar();
    return;
  }
  $("#liste").hidden = false; $("#boardslot").innerHTML = ""; delete $("#boardslot").dataset.c;
  if (key !== listKey) { listKey = key; rowsCache = sorted(S.col, items); renderList(); }
  markRows();
  syncBar();
  if (S.view === "map") renderMap(items, changed); else { $("#mapslot").innerHTML = ""; mapKey = ""; }
}
const colStyle = c => {
  const m = /^minmax\(([^,]+),\s*([\d.]+)fr\)$/.exec(c.w || "");
  return m ? `flex:${m[2]} 1 ${m[1]}` : `flex:0 0 ${c.w || "5rem"}`;
};
const colClass = c => [c.pri === 3 ? "p3" : c.pri === 2 ? "p2" : "", c.align === "r" ? "r" : ""].filter(Boolean).join(" ");
function renderList() {
  const c = cfgOf(S.col), cols = c.columns || [];
  const el = $("#liste");
  if (!rowsCache.length) {
    const others = ORDER.filter(id => id !== S.col).map(id => [id, COLS[id].items.filter(passQ).length]).filter(x => x[1]);
    const hasF = Object.values(sel(S.col)).some(s => s.size);
    el.innerHTML = `<div class="empty"><h3>Rien dans ${esc(c.label)}${S.q ? ` pour « ${esc(S.q)} »` : ""}</h3>${hasF ? `<p>Des filtres sont actifs : <button class="tlink" data-act="clearf">les effacer</button>.</p>` : ""}${others.length && S.qn.length ? `<p>Ailleurs : ${others.map(([id, n]) => `<a href="#v-${id}">${esc(fmtNum(n, 0))} dans ${esc(cfgOf(id).label)}</a>`).join(", ")}.</p>` : ""}</div>`;
    return;
  }
  const st = curSort(S.col);
  const head = `<div class="thead"><span class="c-name"><button data-sort="${esc((c.sort || [])[0]?.id || "")}">${esc(c.nameLabel || "Nom")}</button></span>${cols.map(x => {
    const on = x.sort && st.id === x.sort;
    return `<span class="${colClass(x)}" style="${colStyle(x)}" ${x.sort ? `aria-sort="${on ? (st.dir === "desc" ? "descending" : "ascending") : "none"}"` : ""}>${x.sort ? `<button data-sort="${esc(x.sort)}">${esc(x.label)}${on ? (st.dir === "desc" ? ICO.down : ICO.up) : ""}</button>` : esc(x.label)}</span>`;
  }).join("")}<span class="c-pick"></span></div>`;
  shown = 0;
  const hasHeat = cols.some(x => x.fmt === "heat");
  el.innerHTML = (hasHeat ? `<div class="hlegw" style="padding:.5rem .5rem .625rem">${heatLegend()}</div>` : "") + head + `<div id="rows"></div><div class="sentinel" id="sentinel"></div>`;
  moreRows(60);
  if (io) { io.disconnect(); io.observe($("#sentinel")); }
}
function hilite(s) {
  const t = esc(s);
  if (!S.qn.length) return t;
  const w = S.qn[0]; if (w.length < 2) return t;
  const i = norm(s).indexOf(w);
  if (i < 0 || norm(s).length !== s.length) return t;
  return `${esc(s.slice(0, i))}<mark>${esc(s.slice(i, i + w.length))}</mark>${esc(s.slice(i + w.length))}`;
}
function rowHtml(it) {
  const c = cfgOf(it.col), cols = c.columns || [];
  const th = c.thumb ? get(it.raw, c.thumb) : null;
  const inCmp = (S.cmp[it.col] || []).includes(it.id);
  const phone = cols.filter(x => x.phone && known(x.path ? get(it.view, x.path) : null)).slice(0, 2);
  return `<div class="row" data-id="${esc(it.id)}"><a class="title c-name" href="#f-${it.col}-${esc(it.id)}">${th ? `<img class="thumb" loading="lazy" alt="" src="${esc(img(th))}">` : c.thumb ? `<span class="thumb tph">${logoHtml(it)}</span>` : logoHtml(it)}<div class="tx"><b>${hilite(it.title)}${marksHtml(it)}</b><small>${esc(it.sub)}</small></div></a>${cols.map(x => {
    const ph = phone.includes(x);
    return `<div class="cell ${colClass(x)} ${ph ? "ph" : ""}" style="${colStyle(x)}">${fmtVal(x, it)}${ph && x.short ? `<small>${esc(x.short)}</small>` : ""}</div>`;
  }).join("")}<span class="c-pick"><button class="pick" data-pick="${esc(it.id)}" aria-pressed="${inCmp}" aria-label="${inCmp ? "Retirer de la comparaison" : "Ajouter à la comparaison"}" title="Comparer">${inCmp ? ICO.check : ICO.plus}</button></span></div>`;
}
function moreRows(n) {
  const box = $("#rows"); if (!box) return;
  const next = rowsCache.slice(shown, shown + n);
  if (!next.length) return;
  box.insertAdjacentHTML("beforeend", next.map(rowHtml).join(""));
  shown += next.length;
  markRows();
}
const io = "IntersectionObserver" in window ? new IntersectionObserver(es => { if (es.some(e => e.isIntersecting)) moreRows(80); }, { rootMargin: "800px" }) : null;
function markRows() {
  const openId = S.open?.col === S.col ? S.open.id : null;
  for (const r of document.querySelectorAll(".row,.brow")) {
    r.classList.toggle("sel", r.dataset.id === openId);
    r.classList.toggle("cur", r.dataset.id === S.cursor && S.kbd);
    const p = r.querySelector(".pick"); if (!p) continue;
    const on = (S.cmp[S.col] || []).includes(r.dataset.id);
    if (p.getAttribute("aria-pressed") !== String(on)) { p.setAttribute("aria-pressed", on); p.innerHTML = on ? ICO.check : ICO.plus; p.setAttribute("aria-label", on ? "Retirer de la comparaison" : "Ajouter à la comparaison"); }
  }
  for (const d of document.querySelectorAll(".pt")) d.classList.toggle("sel", d.dataset.id === openId);
}

/* Carte des positions */
function axisOf(cid, which) {
  const c = cfgOf(cid), st = S.axes[cid] ||= { x: c.map.x, y: c.map.y };
  return c.axes.find(a => a.id === st[which]) || c.axes[0];
}
function niceLin(a, b, n) {
  if (a === b) { a -= 1; b += 1; }
  const step0 = (b - a) / n, mag = 10 ** Math.floor(Math.log10(step0)), r = step0 / mag;
  const step = (r < 1.5 ? 1 : r < 3 ? 2 : r < 7 ? 5 : 10) * mag;
  const lo = Math.floor(a / step) * step, hi = Math.ceil(b / step) * step, t = [];
  for (let v = lo; v <= hi + step / 2; v += step) t.push(+v.toFixed(10));
  return { lo, hi, ticks: t };
}
function niceLog(a, b) {
  const base = [1, 2, 5]; const t = [];
  for (let e = Math.floor(Math.log10(a)); e <= Math.ceil(Math.log10(b)); e++) for (const m of base) { const v = m * 10 ** e; t.push(+v.toPrecision(3)); }
  const lo = Math.max(...t.filter(v => v <= a)), hi = Math.min(...t.filter(v => v >= b));
  return { lo, hi, ticks: t.filter(v => v >= lo && v <= hi) };
}
function scaleFor(ax, vals, size, rev) {
  const flip = p => rev ? size - p : p;
  if (ax.scale === "discrete") {
    const order = ax.values || [...new Set(vals)].sort();
    const seen = order.filter(v => ax.values || vals.includes(v));
    const bw = size / seen.length;
    return { discrete: true, bw, order: seen, pos: v => flip((seen.indexOf(v) + .5) * bw), ticks: seen, fmt: v => ax.dict ? dict(ax.dict, v) : String(v) };
  }
  if (ax.scale === "date") {
    const ts = vals.map(v => parseDate(v)?.getTime()).filter(Boolean);
    const lo = Math.min(...ts), hi = Math.max(...ts), pad = (hi - lo || 864e5) * .05;
    const a = lo - pad, b = hi + pad, span = b - a;
    const months = span / (30.4 * 864e5), stepM = months > 48 ? 12 : months > 20 ? 6 : months > 9 ? 3 : months > 3 ? 1 : 1;
    const out = []; const d = new Date(a); d.setDate(1); d.setMonth(Math.ceil(d.getMonth() / stepM) * stepM); d.setHours(0, 0, 0, 0);
    while (d.getTime() <= b) { if (d.getTime() >= a) out.push(d.getTime()); d.setMonth(d.getMonth() + stepM); }
    return { pos: v => flip((parseDate(v).getTime() - a) / span * size), ticks: out, tickPos: t => flip((t - a) / span * size), fmt: t => { const x = new Date(t); return x.getMonth() === 0 ? String(x.getFullYear()) : `${String(x.getMonth() + 1).padStart(2, "0")}/${String(x.getFullYear()).slice(2)}`; } };
  }
  const nums = vals.filter(v => typeof v === "number");
  if (ax.scale === "log") {
    const pos = nums.filter(v => v > 0), s = niceLog(Math.min(...pos), Math.max(...pos));
    const l = Math.log(s.lo), h = Math.log(s.hi) - l || 1;
    let ticks = s.ticks; if (ticks.length > 7) ticks = ticks.filter(t => /^1/.test(t.toPrecision(1)) || /^5/.test(t.toPrecision(1)));
    return { pos: v => flip((Math.log(v) - l) / h * size), ticks, fmt: v => ax.fmt === "usd" ? usd(v) : fmtNum(v, 3) };
  }
  const s = niceLin(Math.min(...nums), Math.max(...nums), size < 260 ? 4 : 6);
  return { pos: v => flip((v - s.lo) / (s.hi - s.lo) * size), ticks: s.ticks, fmt: v => ax.fmt === "usd" ? usd(v) : fmtNum(v, 2) };
}
function renderMap(items, anim) {
  const cid = S.col, c = cfgOf(cid);
  const ax = axisOf(cid, "x"), ay = axisOf(cid, "y");
  const slot = $("#mapslot");
  if (!$("#map") || slot.dataset.c !== cid) {
    slot.dataset.c = cid;
    slot.innerHTML = `<div class="mapwrap"><div class="maphead" id="maphead"></div><div class="map" id="map"><svg role="img"><g id="gridg"></g><g id="frontg"></g><g id="ptsg"></g><g class="labs" id="labg"></g></svg><div class="tip" id="tip" hidden></div><div class="mapnone" id="mapnone" hidden></div></div><div class="mapnote" id="mapnote"></div></div>`;
    S._pts = new Map();
  }
  const opts = (w, cur) => c.axes.map(a => `<option value="${esc(a.id)}" ${a.id === cur.id ? "selected" : ""}>${esc(a.label)}</option>`).join("");
  const fill = c.map.fill;
  const numeric = a => a.better && a.scale !== "date" && a.scale !== "discrete";
  const plotted = items.filter(it => known(get(it.view, ax.path)) && known(get(it.view, ay.path)) && (ax.scale !== "log" || get(it.view, ax.path) > 0) && (ay.scale !== "log" || get(it.view, ay.path) > 0));
  $("#maphead").innerHTML = `<label class="selectwrap"><span>Horizontal</span><select id="axx" aria-label="Axe horizontal">${opts("x", ax)}</select>${ICO.chev}</label><label class="selectwrap"><span>Vertical</span><select id="axy" aria-label="Axe vertical">${opts("y", ay)}</select>${ICO.chev}</label><span class="legend">${fill ? `<span><i class="on"></i>${esc(fill.on)}</span><span><i></i>${esc(fill.off)}</span>` : ""}${numeric(ax) && numeric(ay) ? `<span data-tip="Aucune autre fiche n'est à la fois meilleure sur les deux axes."><i class="line"></i>Frontière</span>` : ""}</span><span class="right">${esc(fmtNum(plotted.length, 0))} sur ${esc(fmtNum(items.length, 0))} placés${plotted.length < items.length ? ", valeur inconnue pour les autres" : ""}</span>`;
  const box = $("#map"), W = box.clientWidth, H = box.clientHeight;
  if (!W || !H) return;
  const small = W < 560;
  const hasDiscY = ay.scale === "discrete" && !ay.values?.every(v => typeof v === "number");
  const m = { l: small ? (hasDiscY ? 62 : 40) : (hasDiscY ? 92 : 52), r: 14, t: 22, b: 34 };
  const iw = W - m.l - m.r, ih = H - m.t - m.b;
  const svg = box.querySelector("svg");
  svg.classList.toggle("noanim", !anim);
  svg.setAttribute("viewBox", `0 0 ${W} ${H}`);
  svg.setAttribute("aria-label", `Position des fiches : ${ax.label} et ${ay.label}`);
  $("#mapnone").hidden = plotted.length > 0;
  if (!plotted.length) { $("#mapnone").textContent = "Aucune fiche n'a ces deux valeurs. Change d'axe ou retire un filtre."; }
  const gridg = $("#gridg"), ptsg = $("#ptsg"), labg = $("#labg");
  $("#mapnote").innerHTML = "";
  if (!plotted.length) { gridg.innerHTML = ""; labg.innerHTML = ""; $("#frontg").innerHTML = ""; for (const [, g] of S._pts) g.remove(); S._pts.clear(); return; }
  const xs = scaleFor(ax, plotted.map(it => get(it.view, ax.path)), iw, false);
  const ys = scaleFor(ay, plotted.map(it => get(it.view, ay.path)), ih, true);
  const tx = t => m.l + (xs.tickPos ? xs.tickPos(t) : xs.pos(t));
  const ty = t => m.t + (ys.tickPos ? ys.tickPos(t) : ys.pos(t));
  let g = "";
  const xt = xs.discrete ? xs.ticks : thin(xs.ticks, small ? 4 : 8);
  for (const t of xt) {
    const x = Math.round(tx(t)) + .5;
    if (xs.discrete) { const b = Math.round(x - xs.bw / 2) + .5; if (t !== xt[0]) g += `<line class="grid" x1="${b}" x2="${b}" y1="${m.t}" y2="${m.t + ih}"/>`; }
    else g += `<line class="grid" x1="${x}" x2="${x}" y1="${m.t}" y2="${m.t + ih}"/>`;
    g += `<text x="${x}" y="${m.t + ih + 15}" text-anchor="middle">${esc(trimTo(xs.fmt(t), xs.discrete ? xs.bw : 90))}</text>`;
  }
  for (const t of ys.ticks) {
    const y = Math.round(ty(t)) + .5;
    if (ys.discrete) { const b = Math.round(y + ys.bw / 2) + .5; if (t !== ys.ticks[0]) g += `<line class="grid" x1="${m.l}" x2="${m.l + iw}" y1="${b}" y2="${b}"/>`; }
    else g += `<line class="grid" x1="${m.l}" x2="${m.l + iw}" y1="${y}" y2="${y}"/>`;
    g += `<text x="${m.l - 7}" y="${y + 3.5}" text-anchor="end">${esc(trimTo(ys.fmt(t), m.l - 8))}</text>`;
  }
  g += `<line class="axis" x1="${m.l}" x2="${m.l + iw}" y1="${m.t + ih + .5}" y2="${m.t + ih + .5}"/>`;
  g += `<text class="atitle" x="${m.l + iw}" y="${H - 4}" text-anchor="end">${esc(ax.label)}${ax.scale === "log" ? ", échelle log" : ""}</text>`;
  g += `<text class="atitle" x="${m.l}" y="11">${esc(ay.label)}</text>`;
  gridg.innerHTML = g;
  // Positions, avec empilement dans les cases discrètes
  const cell = new Map(), P = [];
  for (const it of plotted) {
    const vx = get(it.view, ax.path), vy = get(it.view, ay.path);
    const key = `${xs.discrete ? vx : ""}|${ys.discrete ? vy : ""}`;
    if ((xs.discrete || ys.discrete)) { const arr = cell.get(key) || []; arr.push(it); cell.set(key, arr); }
    P.push({ it, vx, vy, x: m.l + xs.pos(vx), y: m.t + ys.pos(vy) });
  }
  if (cell.size) {
    const R = small ? 11 : 15;
    for (const arr of cell.values()) {
      const n = arr.length, per = Math.max(1, Math.ceil(Math.sqrt(n * 1.6)));
      arr.forEach((it, i) => {
        const p = P.find(q => q.it === it), col = i % per, row = Math.floor(i / per), rows = Math.ceil(n / per), lastN = i >= per * (rows - 1) ? n - per * (rows - 1) : per;
        p.x += (col - (lastN - 1) / 2) * R; p.y += (row - (rows - 1) / 2) * R;
      });
    }
  }
  const seen = new Set();
  for (const p of P) {
    seen.add(p.it.id);
    let node = S._pts.get(p.it.id);
    if (!node) {
      node = document.createElementNS("http://www.w3.org/2000/svg", "g");
      node.innerHTML = `<circle class="hit" r="14"/><circle class="dot" r="5.25"/>`;
      node.dataset.id = p.it.id;
      node.style.transition = "none";
      node.style.transform = `translate(${p.x}px,${p.y}px)`;
      ptsg.appendChild(node);
      S._pts.set(p.it.id, node);
      requestAnimationFrame(() => { node.style.transition = ""; });
    }
    node.setAttribute("class", `pt ${!fill || truthy(get(p.it.view, fill.path)) ? "on" : ""}`);
    node.style.transform = `translate(${p.x.toFixed(1)}px,${p.y.toFixed(1)}px)`;
    p.node = node;
  }
  for (const [id, n] of S._pts) if (!seen.has(id)) { n.remove(); S._pts.delete(id); }
  // Frontière et sens du mieux
  const frontg = $("#frontg");
  const hasFront = numeric(ax) && numeric(ay);
  const front = hasFront ? pareto(P.map(p => ({ p, x: p.vx, y: p.vy })), ax.better, ay.better).map(q => q.p).sort((a, b) => a.x - b.x) : [];
  const frontSet = new Set(front);
  for (const p of P) p.node.classList.toggle("front", frontSet.has(p));
  let fd = "";
  if (front.length > 1) {
    const hv = (ax.better === "low") === (ay.better === "high");
    front.forEach((p, i) => { if (!i) fd = `M${p.x.toFixed(1)} ${p.y.toFixed(1)}`; else fd += hv ? `H${p.x.toFixed(1)}V${p.y.toFixed(1)}` : `V${p.y.toFixed(1)}H${p.x.toFixed(1)}`; });
  }
  frontg.innerHTML = fd ? `<path class="frontl" d="${fd}"/>` : "";
  const drawBetter = () => {
    if (!hasFront) return;
    const left = ax.better === "low", top = ay.better === "high";
    const cx = left ? m.l + 10 : m.l + iw - 10, cy = top ? m.t + 12 : m.t + ih - 12, sx = left ? -1 : 1, sy = top ? -1 : 1;
    const ax0 = cx - sx * 0, ay0 = cy - sy * 0;
    const tip = `M${ax0 + sx * 3} ${ay0 + sy * 3}L${ax0 - sx * 7} ${ay0 - sy * 7}M${ax0 + sx * 3} ${ay0 + sy * 3}h${-sx * 5}M${ax0 + sx * 3} ${ay0 + sy * 3}v${-sy * 5}`;
    labg.insertAdjacentHTML("beforeend", `<g class="better"><path d="${tip}"/><text x="${cx - sx * 11}" y="${cy + 4 - sy * 6}" text-anchor="${left ? "start" : "end"}">Mieux</text></g>`);
  };
  const scoreAxis = [ay, ax].find(a => /elo|arena/i.test(a.path || ""));
  const k = scoreAxis && (c.board?.criteria || []).find(x => x.path === scoreAxis.path);
  $("#mapnote").innerHTML = [scoreAxis && CFG.explain?.elo ? esc(CFG.explain.elo) : "", k ? srcHtml(k) : ""].filter(Boolean).join(" ");
  // Etiquettes : uniquement là où elles tiennent
  const ctx = (renderMap._c ||= document.createElement("canvas").getContext("2d")); ctx.font = `500 11px ${getComputedStyle(document.body).fontFamily}`;
  const boxes = P.map(p => ({ x1: p.x - 6, x2: p.x + 6, y1: p.y - 6, y2: p.y + 6 }));
  const hit = (b, list) => list.some(o => b.x1 < o.x2 && b.x2 > o.x1 && b.y1 < o.y2 && b.y2 > o.y1);
  const maxLab = small ? 10 : Math.round(iw / 30);
  const order = P.slice().sort((a, b) => (frontSet.has(b) - frontSet.has(a)) || (typeof b.vy === "number" && typeof a.vy === "number" ? b.vy - a.vy : 0));
  // Ouvrir d'abord les extrêmes : haut et bas prix
  const used = [], labs = [];
  if (hasFront) { const L = ax.better === "low", T = ay.better === "high", bx = L ? m.l : m.l + iw - 56, by = T ? m.t : m.t + ih - 24; used.push({ x1: bx, x2: bx + 56, y1: by, y2: by + 24 }); }
  for (const p of order) {
    if (labs.length >= maxLab) break;
    const t = stripParens(p.it.title).slice(0, 28);
    const w = ctx.measureText(t).width + 4;
    const cands = [[9, 3.5, "start"], [-9, 3.5, "end"], [0, -9, "middle"], [0, 15, "middle"]];
    for (const [dx, dy, an] of cands) {
      const x1 = an === "start" ? p.x + dx : an === "end" ? p.x + dx - w : p.x - w / 2, y1 = p.y + dy - 9;
      const b = { x1, x2: x1 + w, y1, y2: y1 + 12 };
      if (b.x1 < m.l - 2 || b.x2 > W - 2 || b.y1 < m.t || b.y2 > m.t + ih) continue;
      const others = boxes.filter((o, i) => P[i] !== p);
      if (hit(b, used) || hit(b, others)) continue;
      used.push(b); labs.push(`<text class="lab" x="${(p.x + dx).toFixed(1)}" y="${(p.y + dy).toFixed(1)}" text-anchor="${an}">${esc(t)}</text>`);
      break;
    }
  }
  labg.innerHTML = labs.join("");
  drawBetter();
  if (anim && !matchMedia("(prefers-reduced-motion:reduce)").matches) { labg.style.opacity = 0; clearTimeout(S._lt); S._lt = setTimeout(() => { labg.style.opacity = 1; }, 230); } else { clearTimeout(S._lt); labg.style.opacity = 1; }
  S._P = P; S._ax = { ax, ay, W, H };
  markRows();
}
function trimTo(s, px) { s = String(s); const n = Math.floor(px / 6); return s.length > n && n > 3 ? s.slice(0, n - 1) + "…" : s; }
function thin(t, max) { if (t.length <= max) return t; const k = Math.ceil(t.length / max); return t.filter((_, i) => i % k === 0); }
function showTip(id) {
  const tip = $("#tip"); if (!tip) return;
  const p = S._P?.find(q => q.it.id === id);
  if (!p) { tip.hidden = true; return; }
  const { ax, ay, W } = S._ax;
  const fv = (a, v) => a.scale === "date" ? fmtDate(v) : a.fmt === "usd" && typeof v === "number" ? usd(v) : a.dict ? dict(a.dict, v) : typeof v === "number" ? fmtNum(v, 3) : v;
  tip.innerHTML = `<b>${esc(p.it.title)}</b><span>${esc(ax.label)} : ${esc(fv(ax, p.vx))}</span><span>${esc(ay.label)} : ${esc(fv(ay, p.vy))}</span>`;
  tip.hidden = false;
  const r = tip.getBoundingClientRect();
  const left = p.x + 12 + r.width > W ? p.x - 12 - r.width : p.x + 12;
  tip.style.left = Math.max(0, left) + "px";
  tip.style.top = Math.max(0, p.y - r.height - 8) + "px";
}

/* Classement : tout vient de la configuration, aucune note n'est calculée au-delà de ce qui est affiché */
const collF = new Intl.Collator(FR, { sensitivity: "base", numeric: true });
function pareto(list, xb, yb) {
  const sx = xb === "low" ? 1 : -1, sy = yb === "high" ? 1 : -1;
  let best = -Infinity; const out = [];
  for (const p of list.slice().sort((a, b) => (a.x - b.x) * sx || (b.y - a.y) * sy)) { if (p.y * sy > best) { best = p.y * sy; out.push(p); } }
  return out;
}
const critOf = cid => { const b = cfgOf(cid).board; return b.criteria.find(x => x.id === S.crit[cid]) || b.criteria.find(x => x.id === b.default) || b.criteria[0]; };
const shortTitle = it => cfgOf(it.col).board?.stripTitle ? stripParens(it.title) : it.title;
function marksOf(it) {
  const out = [];
  for (const m of cfgOf(it.col).marks || []) { const v = get(it.raw, m.path); if (m.in ? m.in.includes(v) : truthy(v)) out.push(m); }
  return out;
}
const marksHtml = it => marksOf(it).map(m => `<span class="mk" role="img" aria-label="${esc(m.label)}" data-tip="${esc(m.tip || m.label)}">${ico(m.icon)}</span>`).join("");
const marksTags = it => { const a = marksOf(it); return a.length ? `<div class="itags">${a.map(m => `<span class="tag good" style="display:inline-flex;gap:.25rem;align-items:center">${ico(m.icon)}${esc(m.label)}</span>`).join("")}</div>` : ""; };
function relationHtml(it) {
  const r = CFG.relations?.[it.raw[cfgOf(it.col).idKey || "id"]]; if (!r) return "";
  const links = (r.open || []).map(id => { const t = COLS[it.col].byId.get(id); return t ? `<a href="#f-${it.col}-${esc(t.id)}">${esc(t.title)}</a>` : ""; }).filter(Boolean).join(", ");
  return `<p class="callout">${esc(r.note)}${links ? ` Poids ouverts : ${links}.` : ""}</p>`;
}
function srcHtml(cr) {
  let s = cr.src; if (!s) return "";
  if (typeof s === "string") { const o = get(RAW, s) || {}; s = { url: o.url, date: o.date }; }
  const label = cr.srcLabel || s.label || (s.url ? host(s.url) : "");
  const u = safeUrl(s.url);
  return `Source : ${u ? `<a href="${esc(u)}" target="_blank" rel="noopener">${esc(label)}</a>` : esc(label)}${s.date ? `, relevé du ${esc(fmtDate(s.date))}` : ""}.`;
}
function scaleOf(cid, cr) {
  if (cr._hi !== undefined) return cr;
  const vals = COLS[cid].items.map(it => get(it.view, cr.kind === "front" ? cr.y.path : cr.path)).filter(v => typeof v === "number");
  cr._lo = vals.length ? Math.min(...vals) : 0; cr._hi = vals.length ? Math.max(...vals) : 1;
  return cr;
}
function boardRows(cid, items, cr) {
  const c = cfgOf(cid), b = c.board, ex = b.exclude;
  const isEx = it => ex && ex.in.includes(get(it.view, ex.path));
  const pool = items.filter(it => !isEx(it)), aside = [];
  const gone = items.filter(isEx);
  let rows = [];
  const byName = (a, b) => collF.compare(a.it.title, b.it.title);
  if (cr.kind === "sum") {
    const min = S.min[cid] ?? cr.min, all = pool.map(it => { const v = cr.paths.map(p => get(it.view, p)).filter(x => typeof x === "number"); return { it, n: v.length, sum: v.reduce((x, y) => x + y, 0) }; });
    const none = all.filter(r => !r.n), under = all.filter(r => r.n && r.n < min).sort((x, y) => y.n - x.n || byName(x, y));
    rows = all.filter(r => r.n >= min).map(r => ({ ...r, v: r.sum / (r.n * cr.max) })).sort((x, y) => y.v - x.v || y.n - x.n || byName(x, y));
    if (under.length) aside.push({ label: `Moins de ${min} critères notés sur ${cr.paths.length}`, rows: under, tail: r => `${r.n}/${cr.paths.length}` });
    if (none.length) aside.push({ label: "Non évalués : aucune note", rows: none.sort(byName) });
  } else if (cr.kind === "front") {
    const all = pool.map(it => ({ it, x: get(it.view, cr.x.path), y: get(it.view, cr.y.path), ci: cr.y.ci ? get(it.view, cr.y.ci) : null }));
    const okk = all.filter(r => typeof r.x === "number" && typeof r.y === "number");
    const fr = pareto(okk, cr.x.better, cr.y.better);
    rows = fr.map(r => ({ ...r, v: r.y })).sort((x, y) => cr.y.better === "high" ? y.v - x.v : x.v - y.v);
    const dom = okk.filter(r => !fr.includes(r)).sort((x, y) => y.y - x.y);
    if (dom.length) aside.push({ label: "Dépassés : une autre fiche est à la fois moins chère et mieux notée", rows: dom.map(r => ({ ...r })) });
    const nope = all.filter(r => !okk.includes(r));
    if (nope.length) aside.push({ label: `Non classés : score ou prix absent des données`, rows: nope.sort(byName) });
  } else {
    const all = pool.map(it => ({ it, v: get(it.view, cr.path), ci: cr.ci ? get(it.view, cr.ci) : null, votes: cr.votes ? get(it.view, cr.votes) : null, srcRank: cr.rank ? get(it.view, cr.rank) : null, just: cr.just ? get(it.view, cr.just) : null }));
    rows = all.filter(r => typeof r.v === "number").sort((x, y) => (cr.dir === "asc" ? x.v - y.v : y.v - x.v) || byName(x, y));
    const nope = all.filter(r => typeof r.v !== "number");
    if (nope.length) aside.push({ label: cr.kind === "note" ? "Non évalués sur ce critère" : "Non classés : pas de valeur dans les données", rows: nope.sort(byName) });
  }
  if (gone.length) aside.push({ label: ex.label, rows: gone.map(it => ({ it })) });
  let rk = 0, prev = null;
  rows.forEach((r, i) => {
    if (!prev || prev.v !== r.v) rk = i + 1;
    r.rank = rk;
    r.tie = !!(prev && (typeof r.ci === "number" || typeof prev.ci === "number") && Math.abs(prev.v - r.v) <= Math.max(prev.ci || 0, r.ci || 0));
    r.exact = !!(prev && prev.v === r.v) || (rows[i + 1] && rows[i + 1].v === r.v);
    prev = r;
  });
  return { rows, aside };
}
function rowParts(r, cr, cid) {
  const c = cfgOf(cid), b = c.board;
  scaleOf(cid, cr);
  let pct = 0, wh = null, big = "", small = "";
  if (cr.kind === "sum") { pct = r.v * 100; big = `${fmtNum(r.sum, 0)} / ${fmtNum(r.n * cr.max, 0)}`; small = `${r.n} critères sur ${cr.paths.length}`; }
  else if (cr.kind === "note") { pct = r.v / cr.max * 100; big = `${r.v} / ${cr.max}`; }
  else if (cr.kind === "price") { pct = r.v / ((S._bmax) || 1) * 100; big = usd(r.v); small = cr.unit || ""; }
  else if (cr.kind === "measure") { pct = r.v / ((S._bmax) || 1) * 100; big = fmtNum(r.v, cr.d ?? 1) + (cr.unit ? " " + cr.unit : ""); }
  else {
    const span = (cr._hi - cr._lo) || 1, val = r.v;
    pct = 6 + (val - cr._lo) / span * 94; big = fmtNum(val, cr.d ?? 0);
    if (typeof r.ci === "number") { small = `± ${fmtNum(r.ci, 0)}`; const a = 6 + (val - r.ci - cr._lo) / span * 94, z = 6 + (val + r.ci - cr._lo) / span * 94; wh = [Math.max(0, a), Math.min(100, z)]; }
    if (cr.kind === "front") small = usd(r.x) + (cr.x.unit ? " " + cr.x.unit : "");
  }
  return { pct: Math.max(0, Math.min(100, pct)), wh, big, small };
}
function bnameHtml(r, cr, cid) {
  const it = r.it, c = cfgOf(cid);
  const stat = (c.tags || []).filter(t => t.dict === "status").map(t => { const v = get(it.view, t.path); if (!known(v) || t.hideIf?.includes(v)) return ""; const tone = CFG.tones?.status?.[v]; return `<span class="tagmini ${tone === "warn" ? "warn" : ""}">${esc(dict("status", v))}</span>`; }).join("");
  const rel = CFG.relations?.[it.raw[c.idKey || "id"]];
  const relTag = rel ? `<span class="tagmini" data-tip="${esc(rel.note)}">${esc(rel.tag || "Poids à part")}</span>` : "";
  const sub = cr.kind === "note" && r.just ? r.just : it.sub;
  return `<b>${esc(shortTitle(it))}${marksHtml(it)}${stat}${relTag}</b><small${cr.kind === "note" && r.just ? ` data-full="${esc(r.just)}"` : ""}>${esc(sub)}</small>`;
}
function tipOfRow(r, cr, n) {
  const a = [];
  if (r.srcRank) a.push(`${r.srcRank}e chez la source, toutes variantes comprises`);
  if (r.votes) a.push(`${fmtNum(r.votes, 0)} votes`);
  if (r.tie) a.push("égalité statistique avec le rang précédent");
  return a.join(" · ");
}
function renderBoard(items) {
  const cid = S.col, c = cfgOf(cid), b = c.board, cr = critOf(cid), slot = $("#boardslot");
  if (slot.dataset.c !== cid + "t") {
    slot.dataset.c = cid + "t";
    slot.innerHTML = `<div class="board" id="board"><div id="bleaders"></div><div id="bhead"></div><div class="bnote" id="bnote"></div><div class="brows" id="brows"></div><div class="bfoot" id="bfoot"></div><div class="bnote" id="bexpl"></div><div id="baside"></div></div>`;
  }
  const others = ORDER.filter(id => id !== cid && cfgOf(id).board);
  $("#bleaders").innerHTML = others.length ? `<div class="leaders">${others.map(id => {
    const k = cfgOf(id).board.criteria[0], top = boardRows(id, COLS[id].items, k).rows[0];
    return top ? `<a class="leader" href="#v-${id}" data-tip="${esc(k.label)}">${ico(cfgOf(id).icon)}<div>${esc(cfgOf(id).label)}, n° 1<b>${esc(shortTitle(top.it))}</b></div></a>` : "";
  }).join("")}</div>` : "";
  const on = sel(cid);
  const fp = (b.filters || []).map(x => `<button class="fpill" data-f="${esc(x.f)}" data-o="${esc(x.o)}" aria-pressed="${!!on[x.f]?.has(x.o)}">${ico(x.icon)}${esc(x.label)}</button>`).join("");
  const minS = cr.kind === "sum" ? `<span class="lbl">Seuil, critères notés</span>${[4, 5, 6, 7].map(n => `<button class="minb" data-min="${n}" aria-pressed="${(S.min[cid] ?? cr.min) === n}" aria-label="Au moins ${n} critères notés">${n}</button>`).join("")}` : "";
  const keepL = [$("#bhead .crits")?.scrollLeft || 0, $("#bhead .fpills")?.scrollLeft || 0];
  $("#bhead").innerHTML = `<div class="crits" role="group" aria-label="Critère de classement">${b.criteria.map(k => `<button class="crit" data-crit="${esc(k.id)}" aria-pressed="${k.id === cr.id}">${esc(k.label)}</button>`).join("")}</div>${fp || minS ? `<div class="fpills">${fp}${minS}</div>` : ""}`;
  { const cs = $("#bhead .crits"), fs = $("#bhead .fpills"); cs.scrollLeft = keepL[0]; if (fs) fs.scrollLeft = keepL[1];
    const a = cs.querySelector('[aria-pressed="true"]'); if (a && cs.scrollWidth > cs.clientWidth) { if (a.offsetLeft < cs.scrollLeft + 16) cs.scrollLeft = a.offsetLeft - 16; else if (a.offsetLeft + a.offsetWidth > cs.scrollLeft + cs.clientWidth - 16) cs.scrollLeft = a.offsetLeft + a.offsetWidth - cs.clientWidth + 16; } }
  const R = boardRows(cid, items, cr);
  const nonPrice = cr.kind === "price" || cr.kind === "measure";
  S._bmax = 0;
  const lim = S.boardAll[cid] ? R.rows.length : (b.top || 10), vis = R.rows.slice(0, lim);
  if (nonPrice) S._bmax = Math.max(0, ...vis.map(r => r.v));
  const isScore = cr.kind === "score" || cr.kind === "front";
  const topNote = [b.note, isScore ? CFG.explain?.elo : (cr.kind === "price" || cr.kind === "measure" ? cr.note : "")].filter(Boolean);
  const below = [cr.kind === "price" || cr.kind === "measure" ? "" : cr.note, cr.kind === "sum" ? (cr.noteTpl || "").replace("{min}", S.min[cid] ?? cr.min) : "", CFG.explain?.[cr.explain]].filter(Boolean);
  $("#bnote").innerHTML = `<p>${topNote.map(esc).join(" ")} ${srcHtml(cr) || (b.src ? esc(b.src) : "")}</p>${cr.kind === "sum" || cr.kind === "note" ? `<p style="margin-top:.375rem">${heatLegend()}</p>` : ""}`;
  // Lignes conservées d'un critère à l'autre pour que le mouvement se voie
  const box = $("#brows"), reduce = matchMedia("(prefers-reduced-motion:reduce)").matches;
  const old = new Map(); for (const n of box.children) old.set(n.dataset.id, n.getBoundingClientRect().top);
  const nodes = new Map([...box.children].map(n => [n.dataset.id, n]));
  const flagItems = cr.kind === "sum" ? null : (b.flags || []);
  box.classList.toggle("just", cr.kind === "note");
  box.style.setProperty("--fw", cr.kind === "note" ? "0rem" : flagItems ? `${Math.max(flagItems.length * 1.3, .5)}rem` : "9.25rem");
  const frag = [];
  for (const r of vis) {
    const it = r.it, p = rowParts(r, cr, cid);
    let n = nodes.get(it.id);
    if (!n) {
      n = document.createElement("div"); n.className = "brow"; n.dataset.id = it.id;
      n.innerHTML = `<span class="rk"></span><span class="lgw" style="display:contents"></span><a class="nm" href="#f-${cid}-${esc(it.id)}"></a><span class="bf"></span><span class="track"><i class="fill" style="width:0"></i><i class="wh" hidden></i></span><span class="val"></span><button class="pick" data-pick="${esc(it.id)}" title="Comparer"></button>`;
      n.querySelector(".lgw").innerHTML = logoHtml(it);
      nodes.set(it.id, n);
    }
    const tip = tipOfRow(r, cr);
    const rk = n.querySelector(".rk");
    rk.innerHTML = `${r.tie ? "<small>≈</small>" : ""}${r.rank}`;
    if (tip) { rk.dataset.tip = tip; rk.style.position = "relative"; rk.style.zIndex = 1; } else { delete rk.dataset.tip; rk.style.zIndex = ""; }
    n.querySelector(".nm").innerHTML = bnameHtml(r, cr, cid);
    n.querySelector(".nm").setAttribute("aria-label", `Rang ${r.rank}, ${it.title}, ${p.big}. Ouvrir la fiche et sa justification.`);
    n.querySelector(".bf").innerHTML = cr.kind === "sum" ? heatHtml(cr.paths.map(x => get(it.view, x)), cr.titles, cr.paths.map(x => get(it.view, x.replace(/\.note$/, ".justification")))) : flagsHtml(flagItems, it);
    n.querySelector(".val").innerHTML = `<b>${esc(p.big)}</b>${p.small ? `<small>${esc(p.small)}</small>` : ""}`;
    n._pct = p; frag.push(n);
    n.querySelector(".pick").innerHTML = "";
  }
  for (const n of [...box.children]) if (!frag.includes(n)) n.remove();
  frag.forEach(n => box.appendChild(n));
  void box.offsetHeight;
  for (const n of frag) {
    const f = n.querySelector(".fill"), w = n.querySelector(".wh"), p = n._pct;
    f.style.width = p.pct.toFixed(1) + "%";
    if (p.wh) { w.hidden = false; w.style.left = p.wh[0].toFixed(1) + "%"; w.style.width = (p.wh[1] - p.wh[0]).toFixed(1) + "%"; } else w.hidden = true;
    if (!reduce && n.animate) {
      const o = old.get(n.dataset.id), now = n.getBoundingClientRect().top;
      if (o != null && Math.abs(o - now) > 1) n.animate([{ transform: `translateY(${o - now}px)` }, { transform: "none" }], { duration: 340, easing: "cubic-bezier(.32,.72,0,1)" });
      else if (o == null) n.animate([{ opacity: 0 }, { opacity: 1 }], { duration: 220, easing: "ease-out" });
    }
  }
  for (const n of frag) { const q = n.querySelector(".pick"); const onP = (S.cmp[cid] || []).includes(n.dataset.id); q.setAttribute("aria-pressed", onP); q.setAttribute("aria-label", onP ? "Retirer de la comparaison" : "Ajouter à la comparaison"); q.innerHTML = onP ? ICO.check : ICO.plus; }
  rowsCache = vis.map(r => r.it); shown = rowsCache.length;
  $("#bfoot").innerHTML = (!R.rows.length ? `<div class="empty" style="padding:1.25rem 0"><h3>Rien à classer ici</h3><p>Aucune fiche ne passe ces filtres avec une valeur sur ce critère. ${Object.values(sel(cid)).some(s => s.size) ? `<button class="tlink" data-act="clearf">Effacer les filtres</button>.` : ""}</p></div>` : "")
    + (R.rows.length > (b.top || 10) ? `<button class="btn" data-act="boardall">${S.boardAll[cid] ? "Revenir au top " + (b.top || 10) : `Tout voir (${R.rows.length})`}</button>` : "")
    + `<a class="btn" href="#v-${cid}-liste">${ICO.list}<span>Toutes les fiches</span></a>`;
  const fl = (b.flags || []).map(x => `<span>${ico(x.icon)}${esc(x.label)}</span>`).join("");
  $("#bexpl").innerHTML = `${below.map(x => `<p>${esc(x)}</p>`).join("")}${fl ? `<p class="flleg">${fl}</p>` : ""}`;
  const asideN = R.aside.reduce((a, g) => a + g.rows.length, 0);
  const openA = S.expand["a" + cid + cr.id];
  $("#baside").innerHTML = asideN ? `<details class="aside" ${b.asideOpen || openA ? "open" : ""}><summary>${esc(fmtNum(asideN, 0))} ${cr.kind === "front" ? "hors frontière" : "hors classement, une absence de note ne vaut jamais 0"}</summary>${R.aside.map(g => `<h4>${esc(g.label)} (${g.rows.length})</h4><div class="asidel">${g.rows.map(r => `<a href="#f-${cid}-${esc(r.it.id)}">${esc(shortTitle(r.it))}${g.tail ? `<small>${esc(g.tail(r))}</small>` : ""}</a>`).join("")}</div>`).join("")}</details>` : "";
}
function renderMatrix(items) {
  const cid = S.col, c = cfgOf(cid), b = c.board, mx = b.matrix, slot = $("#boardslot"), cr = critOf(cid);
  const sumC = b.criteria.find(k => k.kind === "sum");
  slot.dataset.c = cid + "m";
  const rows = items.map(it => { const v = mx.paths.map(p => get(it.view, p)), nn = v.filter(x => typeof x === "number"); return { it, v, n: nn.length, sum: nn.reduce((a, x) => a + x, 0) }; });
  const rated = rows.filter(r => r.n), none = rows.filter(r => !r.n);
  const noteCol = cr.kind === "note" ? mx.paths.indexOf(cr.path) : -1;
  const min = S.min[cid] ?? sumC?.min ?? 0;
  rated.sort((a, z) => noteCol >= 0 ? ((z.v[noteCol] ?? -1) - (a.v[noteCol] ?? -1)) || (z.sum / z.n - a.sum / a.n) : ((z.n >= min) - (a.n >= min)) || (z.sum / z.n - a.sum / a.n) || z.n - a.n || collF.compare(a.it.title, z.it.title));
  rowsCache = rated.map(r => r.it); shown = rowsCache.length;
  slot.innerHTML = `<div class="mxw">${(b.filters || []).length ? `<div class="fpills" style="margin-top:0">${b.filters.map(x => `<button class="fpill" data-f="${esc(x.f)}" data-o="${esc(x.o)}" aria-pressed="${!!sel(cid)[x.f]?.has(x.o)}">${ico(x.icon)}${esc(x.label)}</button>`).join("")}</div>` : ""}<div class="bnote">${(b.note ? `<p>${esc(b.note)} ${esc(b.src || "")}</p>` : "")}<p>${esc(mx.note || "")}</p><p style="margin-top:.375rem">${heatLegend()}</p></div>
  <table class="mx" style="margin-top:.5rem"><colgroup><col class="n">${mx.paths.map(() => '<col class="c">').join("")}<col class="t"></colgroup><thead><tr><th scope="col">Outil</th>${mx.paths.map((p, i) => { const k = b.criteria.find(x => x.path === p); return `<th scope="col"><button ${k ? `data-crit="${esc(k.id)}"` : ""} aria-pressed="${k?.id === cr.id}" aria-label="Trier par ${esc(mx.titles[i])}" data-tip="${esc(mx.titles[i])}"><span class="ll">${esc(k?.label || mx.short[i])}</span><span class="ls">${esc(mx.short[i])}</span></button></th>`; }).join("")}<th scope="col"><button ${sumC ? `data-crit="${esc(sumC.id)}"` : ""} aria-pressed="${sumC?.id === cr.id}" data-tip="Points obtenus sur les points possibles, critères non notés retirés">Total</button></th></tr></thead><tbody>${rated.map((r, ri) => {
    const href = `#f-${cid}-${esc(r.it.id)}`;
    const sep = noteCol < 0 && r.n < min && (!ri || rated[ri - 1].n >= min) ? `<tr class="sep"><td colspan="${mx.paths.length + 2}">Moins de ${min} critères notés, hors classement</td></tr>` : "";
    return `${sep}<tr class="${r.n < min ? "under" : ""}" data-id="${esc(r.it.id)}"><td><a class="nm" href="${href}">${logoHtml(r.it)}<span class="t">${esc(shortTitle(r.it))}</span>${marksHtml(r.it)}</a></td>${r.v.map((v, i) => `<td><a class="mc" href="${href}" aria-label="${esc(r.it.title)}, ${esc(heatTip(mx.titles[i], v))}" data-tip="${esc(heatTip(mx.titles[i], v, get(r.it.view, mx.paths[i].replace(/\.note$/, ".justification"))))}"><i class="${known(v) ? "v" + v : "vn"}">${known(v) ? v : ""}</i></a></td>`).join("")}<td class="tot">${r.sum}/${r.n * 3}<small>${r.n}/${mx.paths.length} notés</small></td></tr>`;
  }).join("")}</tbody></table>${none.length ? `<details class="aside"><summary>${none.length} sans aucune note, une absence de note ne vaut jamais 0</summary><div class="asidel" style="margin-top:.375rem">${none.map(r => `<a href="#f-${cid}-${esc(r.it.id)}">${esc(shortTitle(r.it))}</a>`).join("")}</div></details>` : ""}</div>`;
}
function ranksHtml(it) {
  const c = cfgOf(it.col), b = c.board; if (!b) return "";
  const lines = [];
  for (const k of b.criteria) {
    const R = boardRows(it.col, COLS[it.col].items, k), r = R.rows.find(x => x.it === it);
    if (r && k.kind !== "note") lines.push(`<tr><td><a class="tlink" href="#v-${it.col}-top--t-${esc(k.id)}">${esc(k.label)}</a></td><td>${r.rank}<span class="mute"> sur ${R.rows.length}</span></td></tr>`);
    else if (k.kind === "sum" && !r) { const n = k.paths.filter(p => known(get(it.view, p))).length; lines.push(`<tr><td>${esc(k.label)}</td><td class="mute">non classé, ${n} critères notés sur ${k.paths.length}</td></tr>`); }
  }
  return lines.length ? `<div class="isec"><h3>Classements</h3><div class="tw"><table class="t rankt"><tbody>${lines.join("")}</tbody></table></div></div>` : "";
}

/* Fiche */
function itemOf(o) { return o && COLS[o.col]?.byId.get(o.id); }
function coveredPaths(c) {
  const out = new Set(["_", "_j"]);
  const add = f => { if (f.path) out.add(f.path); if (f.items) f.items.forEach(x => out.add(x.path || x)); };
  (c.sections || []).forEach(s => s.fields.forEach(add));
  (c.keys || []).forEach(add);
  (c.hiddenFields || []).forEach(p => out.add(p));
  (c.title || []).forEach(p => out.add(p)); (c.subtitle || []).forEach(p => out.add(p));
  if (c.thumb) out.add(c.thumb); if (c.urlPath) out.add(c.urlPath);
  return out;
}
function restPaths(raw, cov, pre = "") {
  const out = [];
  for (const [k, v] of Object.entries(raw)) {
    const p = pre ? pre + "." + k : k;
    if (!known(v)) continue;
    if (cov.has(p)) continue;
    if ([...cov].some(x => x.startsWith(p + ".")) && v && typeof v === "object" && !Array.isArray(v)) { out.push(...restPaths(v, cov, p)); continue; }
    out.push(p);
  }
  return out;
}
function ficheBody(it) {
  const c = cfgOf(it.col);
  const th = c.thumb ? get(it.raw, c.thumb) : null;
  const url = c.urlPath ? safeUrl(get(it.raw, c.urlPath)) : null;
  const tags = (c.tags || []).map(t => {
    const v = get(it.view, t.path);
    if (!known(v)) return "";
    if (t.eq !== undefined ? v !== t.eq : (t.when && !truthy(v))) return "";
    if (t.hideIf && t.hideIf.includes(v)) return "";
    const tone = CFG.tones?.[t.dict]?.[v] || t.tone || "";
    return `<span class="tag ${tone}">${esc(t.label || dict(t.dict, v))}${t.datePath && get(it.view, t.datePath) ? ` ${esc(fmtDate(get(it.view, t.datePath)))}` : ""}</span>`;
  }).join("");
  const keys = (c.keys || []).filter(k => known(k.path ? get(it.view, k.path) : null)).map(k => `<div><dt>${esc(k.label)}</dt><dd>${fmtVal(k, it)}</dd></div>`).join("");
  const secs = (c.sections || []).map(s => {
    const fields = s.fields.filter(f => {
      if (f.fmt === "heat" || f.fmt === "badges") return true;
      const v = f.path ? get(it.view, f.path) : undefined;
      if (f.fmt === "grille") return true;
      return f.always || known(v);
    });
    if (!fields.length) return "";
    const rows = fields.map(f => f.full || f.fmt === "table" || f.fmt === "dicttable" || f.fmt === "bullets" || f.fmt === "sources" || f.fmt === "promotions"
      ? `${f.label && !f.noLabel && !(fields.length === 1) ? `<dt class="full">${esc(f.label)}</dt>` : ""}<dd class="full">${fmtVal(f, it)}</dd>`
      : `<dt>${esc(f.label)}</dt><dd>${fmtVal(f, it)}</dd>`).join("");
    return `<div class="isec"><h3>${esc(s.title)}</h3><dl class="fields">${rows}</dl></div>`;
  }).join("");
  const rest = restPaths(it.raw, coveredPaths(c));
  const restHtml = rest.length ? `<div class="isec"><h3>Autres champs</h3><dl class="fields">${rest.map(p => `<dt>${esc(labelFor(p.split(".").pop(), p))}</dt><dd>${autoVal(get(it.raw, p), p)}</dd>`).join("")}</dl></div>` : "";
  const inCmp = (S.cmp[it.col] || []).includes(it.id);
  const checked = c.checkedPath ? get(it.view, c.checkedPath) : null;
  return `<div class="ibody"><div class="ihd">${th ? "" : logoHtml(it)}<div style="min-width:0"><h2>${esc(it.title)}</h2><p class="isub">${esc(it.sub)}</p></div></div>${tags ? `<div class="itags">${tags}</div>` : ""}${relationHtml(it)}${th ? (url ? `<a class="ishotlink" href="${esc(url)}" target="_blank" rel="noopener" title="Ouvrir le site source"><img class="ishot" alt="Capture de ${esc(it.title)}" src="${esc(img(th))}"></a>` : `<img class="ishot" alt="Capture de ${esc(it.title)}" src="${esc(img(th))}">`) : ""}${marksTags(it)}<div style="display:flex;gap:.375rem;flex-wrap:wrap;margin-bottom:.5rem"><button class="btn" data-pick="${esc(it.id)}" aria-pressed="${inCmp}">${inCmp ? ICO.check + "Dans la comparaison" : ICO.plus + "Comparer"}</button><button class="btn" data-act="copylink">${ICO.link}<span>Copier le lien</span></button>${url ? `<a class="btn" href="${esc(url)}" target="_blank" rel="noopener">${ICO.ext}${esc(host(url))}</a>` : ""}</div>${keys ? `<dl class="ikey">${keys}</dl>` : ""}${ranksHtml(it)}${secs}${restHtml}${checked ? `<p class="mute" style="font-size:.75rem;margin:1.25rem 0 0">Dernière source datée : ${esc(fmtDate(checked))}, ${esc(ageWords(daysSince(checked)))}.</p>` : ""}</div>`;
}
let inspKey = "";
let wasOpen = false;
function renderInspector() {
  const el = $("#insp"), it = itemOf(S.open), app = $("#app"), scrim = $("#scrim");
  const show = !!it;
  const kb = document.body.classList.contains("kbd");
  if (show && !wasOpen && kb) requestAnimationFrame(() => el.focus({ preventScroll: true }));
  if (!show && wasOpen && kb) requestAnimationFrame(() => document.querySelector(`.row[data-id="${CSS.escape(S.cursor || "")}"] a,.brow[data-id="${CSS.escape(S.cursor || "")}"] a`)?.focus({ preventScroll: true }));
  wasOpen = show;
  el.classList.toggle("show", show);
  app.classList.toggle("docked", show);
  scrim.classList.toggle("show", show);
  if (!it) { inspKey = ""; return; }
  const k = `${it.col}/${it.id}/${(S.cmp[it.col] || []).includes(it.id)}`;
  if (k !== inspKey) {
    inspKey = k;
    el.innerHTML = `<div class="ihead"><button class="icobtn" data-act="close" aria-label="Fermer la fiche">${ICO.x}</button><span class="sp"></span><button class="icobtn" data-act="prev" aria-label="Fiche précédente" title="Précédente">${ICO.up}</button><button class="icobtn" data-act="next" aria-label="Fiche suivante" title="Suivante">${ICO.down}</button></div>${ficheBody(it)}`;
    el.scrollTop = 0;
  }
}
function renderSheets() {
  const fs = $("#fsheet"), as = $("#asheet");
  const f = S.sheet === "filters" && narrow.matches, a = S.sheet === "about";
  fs.classList.toggle("show", f); as.classList.toggle("show", a);
  const scr = $("#scrim");
  scr.classList.toggle("for-insp", !S.sheet);
  if (S.sheet) scr.classList.add("show");
  $("#main").inert = narrow.matches ? !!(S.open || S.sheet) : false;
  if (f) {
    const n = filtered(S.col).length;
    fs.innerHTML = `<div class="ihead"><b style="font-weight:600">Filtres</b><span class="sp"></span><button class="tlink" style="font-size:.8125rem" data-act="clearf">Effacer</button></div><div style="padding:.5rem .75rem">${facetsHtml(S.col)}</div><div style="position:sticky;bottom:0;padding:.75rem 1rem calc(.75rem + env(safe-area-inset-bottom,0px));background:var(--surface);border-top:1px solid var(--line)"><button class="btn primary" style="width:100%;justify-content:center;min-height:2.625rem;font-size:.9375rem" data-act="sheetclose">Voir ${esc(fmtNum(n, 0))} ${esc(n > 1 ? (cfgOf(S.col).nounPlural || "") : (cfgOf(S.col).noun || ""))}</button></div>`;
  }
  if (a && !as.dataset.ok) { as.dataset.ok = "1"; as.innerHTML = aboutHtml(); }
}
function aboutHtml() {
  const counts = ORDER.map(id => `<tr><td>${esc(cfgOf(id).label)}</td><td class="n">${esc(fmtNum(COLS[id].items.length, 0))}</td></tr>`).join("");
  const sections = (CFG.about || []).map(s => `<h3>${esc(s.h)}</h3>${(s.p || []).map(x => `<p>${x}</p>`).join("")}`).join("");
  return `<div class="ihead"><b style="font-weight:600">À propos des données</b><span class="sp"></span><button class="icobtn" data-act="sheetclose" aria-label="Fermer">${ICO.x}</button></div><div class="ibody"><div class="about">${CFG.dataDate ? `<p>Relevé du ${esc(fmtDate(CFG.dataDate))}, ${esc(ageWords(daysSince(CFG.dataDate)))}.${CFG.dataVersion ? ` Version ${esc(CFG.dataVersion)}.` : ""}</p>` : ""}${sections}<h3>Contenu</h3><div class="tw"><table class="t"><tbody>${counts}</tbody></table></div><h3>Affichage</h3><p><button class="btn" data-act="theme"><span class="themelabel">${esc(THEME_LABEL[theme])}</span></button></p><h3>Clavier</h3><p><kbd class="k">/</kbd> rechercher, <kbd class="k">↑</kbd> <kbd class="k">↓</kbd> parcourir, <kbd class="k">Entrée</kbd> ouvrir, <kbd class="k">c</kbd> comparer, <kbd class="k">Échap</kbd> fermer.</p></div></div>`;
}

/* Comparaison */
function compareFields(c) {
  const out = [];
  for (const s of c.sections || []) {
    const fs = s.fields.filter(f => f.fmt !== "sources" && f.fmt !== "table" && f.fmt !== "dicttable" && !f.noCompare);
    if (fs.length) out.push({ title: s.title, fields: fs });
  }
  return out;
}
function compareHtml() {
  const cid = S.col, c = cfgOf(cid), ids = S.cmp[cid] || [];
  const its = ids.map(i => COLS[cid].byId.get(i)).filter(Boolean);
  if (!its.length) return `<div class="cmp"><div class="empty"><h3>Rien à comparer</h3><p>Ajoute des fiches avec le bouton Comparer, puis reviens ici.</p><p><a href="#v-${cid}">Retour à ${esc(c.label)}</a></p></div></div>`;
  const rows = [];
  for (const s of compareFields(c)) {
    const body = [];
    for (const f of s.fields) {
      const vals = its.map(it => fmtVal(f, it));
      const same = vals.every(v => v === vals[0]);
      const none = vals.every(v => v.includes('class="q"') && v.length < 40);
      if (none) continue;
      if (S.diffOnly && same && its.length > 1) continue;
      body.push(`<tr><th scope="row">${esc(f.label)}</th>${vals.map(v => `<td>${v}</td>`).join("")}</tr>`);
    }
    if (body.length) rows.push(`<tr class="sect"><th colspan="${its.length + 1}">${esc(s.title)}</th></tr>${body.join("")}`);
  }
  return `<div class="cmp"><div class="cmp-head"><h2>${esc(fmtNum(its.length, 0))} ${esc(its.length > 1 ? (c.nounPlural || "") : (c.noun || ""))} côte à côte</h2><button class="btn" data-act="diff" aria-pressed="${S.diffOnly}">Seulement ce qui diffère</button><button class="btn" data-act="copylink">${ICO.link}<span>Copier le lien</span></button><a class="btn" href="#${esc(viewHash())}">Retour à la liste</a></div><div class="cmpt"><table class="ctab"><colgroup><col class="lb">${its.map(() => '<col class="v">').join("")}</colgroup><thead><tr><th scope="col"></th>${its.map(it => `<th scope="col"><a href="#f-${cid}-${esc(it.id)}">${esc(it.title)}</a><small>${esc(it.sub)}</small><button class="rm" data-unpick="${esc(it.id)}">${ICO.x}Retirer</button></th>`).join("")}</tr></thead><tbody>${rows.join("") || `<tr><td colspan="${its.length + 1}" class="mute">Ces fiches ne diffèrent sur aucun champ renseigné.</td></tr>`}</tbody></table></div></div>`;
}
function renderTray() {
  const t = $("#tray"), ids = S.cmp[S.col] || [];
  if (S.compare || !ids.length) { t.classList.add("off"); return; }
  const names = ids.map(i => COLS[S.col].byId.get(i)?.title).filter(Boolean).join(", ");
  t.innerHTML = `<span class="names">${esc(names)}</span><a class="btn primary" href="#c-${S.col}--${ids.map(esc).join("--")}">Comparer ${ids.length}</a><button class="icobtn" data-act="clearcmp" aria-label="Vider la comparaison">${ICO.x}</button>`;
  t.classList.remove("off");
}
function togglePick(id) {
  const a = S.cmp[S.col] ||= [];
  const i = a.indexOf(id);
  if (i >= 0) a.splice(i, 1); else { if (a.length >= 6) a.shift(); a.push(id); }
  if (S.compare) { setHash(a.length ? `c-${S.col}--${a.join("--")}` : viewHash(), true); return; }
  markRows(); renderTray(); renderInspector();
  if (S.compare) renderMain();
}

/* Thème */
const THEMES = ["auto", "light", "dark"], THEME_LABEL = { auto: "Thème automatique", light: "Thème clair", dark: "Thème sombre" };
let theme = "auto";
try { theme = localStorage.getItem("atlas-theme") || "auto"; } catch {}
function applyTheme() {
  if (theme === "auto") document.documentElement.removeAttribute("data-theme"); else document.documentElement.setAttribute("data-theme", theme);
  document.querySelectorAll(".themelabel").forEach(l => { l.textContent = THEME_LABEL[theme]; });
}

/* Evénements */
function toggleFacet(f, o) {
  const s = sel(S.col); const set = s[f] ||= new Set();
  const F = facetOf(S.col, f);
  if (set.has(o)) set.delete(o); else { if (F?.type === "threshold") set.clear(); set.add(o); }
  if (!set.size) delete s[f];
  render();
  setHash(viewHash(), true);
}
function closeOverlay() {
  if (S.sheet) { S.sheet = null; if (location.hash === "#a-propos") setHash(viewHash()); $("#scrim").classList.remove("show"); render(); return true; }
  if (S.open) { setHash(viewHash()); return true; }
  if (S.compare) { setHash(viewHash()); return true; }
  return false;
}
function step(d) {
  if (!rowsCache.length) return;
  let i = rowsCache.findIndex(x => x.id === (S.open?.id || S.cursor));
  i = i < 0 ? (d > 0 ? 0 : rowsCache.length - 1) : Math.min(rowsCache.length - 1, Math.max(0, i + d));
  const it = rowsCache[i];
  S.cursor = it.id;
  if (!isBoardView(S.view)) while (i >= shown && shown < rowsCache.length) moreRows(80);
  if (S.open) setHash(`f-${S.col}-${it.id}`, true);
  markRows();
  const r = document.querySelector(`.row[data-id="${CSS.escape(it.id)}"],.brow[data-id="${CSS.escape(it.id)}"]`);
  if (r) r.scrollIntoView({ block: "nearest" });
}
document.addEventListener("click", e => {
  const t = e.target.closest("[data-pick],[data-unpick],[data-act],[data-f],[data-more],[data-sort],[data-crit],[data-min]");
  if (!t) {
    const rowEl = e.target.closest?.(".row,.brow");
    if (rowEl && e.target.closest("[data-tip],.tagmini")) { setHash(`f-${S.col}-${rowEl.dataset.id}`); return; }
    const a = e.target.closest?.('a[href^="#"]');
    if (a && !e.metaKey && !e.ctrlKey && !e.shiftKey) { e.preventDefault(); setHash(a.getAttribute("href").slice(1)); }
    return;
  }
  if (t.dataset.crit !== undefined) { S.crit[S.col] = t.dataset.crit; S.boardAll[S.col] = false; render(); setHash(viewHash(), true); return; }
  if (t.dataset.min !== undefined) { S.min[S.col] = +t.dataset.min; render(); return; }
  if (t.dataset.pick !== undefined) { e.preventDefault(); e.stopPropagation(); togglePick(t.dataset.pick); return; }
  if (t.dataset.unpick !== undefined) { e.preventDefault(); togglePick(t.dataset.unpick); return; }
  if (t.dataset.f) { toggleFacet(t.dataset.f, t.dataset.o); return; }
  if (t.dataset.more) { S.expand[t.dataset.more] = !S.expand[t.dataset.more]; render(); return; }
  if (t.dataset.sort !== undefined) {
    const id = t.dataset.sort; if (!id) return;
    const st = curSort(S.col), k = sortKeys(S.col).find(x => x.id === id);
    S.sort[S.col] = st.id === id ? { id, dir: st.dir === "desc" ? "asc" : "desc" } : { id, dir: k?.dir || "asc" };
    render(); return;
  }
  const a = t.dataset.act;
  if (a === "close") closeOverlay();
  else if (a === "prev") step(-1);
  else if (a === "next") step(1);
  else if (a === "filters") { S.sheet = "filters"; render(); }
  else if (a === "sheetclose") closeOverlay();
  else if (a === "about") { S.sheet = "about"; render(); }
  else if (a === "theme") { theme = THEMES[(THEMES.indexOf(theme) + 1) % 3]; try { localStorage.setItem("atlas-theme", theme); } catch {} applyTheme(); }
  else if (a === "clearq") { setQuery(""); render(); setHash(viewHash(), true); const q = narrow.matches ? $("#q2") : $("#q1"); q?.focus(); }
  else if (a === "clearf") { S.sel[S.col] = {}; render(); setHash(viewHash(), true); }
  else if (a === "clearcmp") { S.cmp[S.col] = []; markRows(); renderTray(); renderInspector(); }
  else if (a === "boardall") { S.boardAll[S.col] = !S.boardAll[S.col]; render(); }
  else if (a === "diff") { S.diffOnly = !S.diffOnly; renderMain(); }
  else if (a === "copylink") {
    const url = location.href; const span = t.querySelector("span");
    const done = ok => { if (span) { const o = span.textContent; span.textContent = ok ? "Lien copié" : url; setTimeout(() => span.textContent = o, 1400); } };
    try { navigator.clipboard.writeText(url).then(() => done(true), () => done(false)); } catch { done(false); }
  }
});
$("#scrim").addEventListener("click", closeOverlay);
document.addEventListener("input", e => {
  if (e.target.id === "q1" || e.target.id === "q2") {
    setQuery(e.target.value);
    render();
    clearTimeout(S._qt); S._qt = setTimeout(() => { if (!S.open && !S.compare && !S.sheet) setHash(viewHash(), true); }, 350);
  }
});
document.addEventListener("change", e => {
  if (e.target.id === "sortsel") { const k = sortKeys(S.col).find(x => x.id === e.target.value); S.sort[S.col] = { id: k.id, dir: k.dir || "asc" }; render(); }
  if (e.target.id === "axx" || e.target.id === "axy") { axisOf(S.col, "x"); S.axes[S.col][e.target.id === "axx" ? "x" : "y"] = e.target.value; renderMap(filtered(S.col), true); }
});
document.addEventListener("pointerdown", () => { document.documentElement.classList.remove("kbd"); document.body.classList.remove("kbd"); if (S.kbd) { S.kbd = false; markRows(); } }, true);
document.addEventListener("keydown", e => {
  const tag = e.target.tagName, typing = tag === "INPUT" || tag === "SELECT" || tag === "TEXTAREA";
  if (e.metaKey || e.ctrlKey || e.altKey) return;
  document.body.classList.add("kbd");
  if (e.key === "/" && !typing) { e.preventDefault(); const q = narrow.matches ? $("#q2") : $("#q1"); q?.focus(); q?.select(); return; }
  if (e.key === "Escape") {
    if (typing && S.q) { setQuery(""); render(); setHash(viewHash(), true); return; }
    if (typing) { e.target.blur(); return; }
    closeOverlay(); return;
  }
  if (typing && tag !== "INPUT") return;
  if (e.key === "ArrowDown" || (!typing && e.key === "j")) { e.preventDefault(); S.kbd = true; if (S.compare) return; step(1); return; }
  if (e.key === "ArrowUp" || (!typing && e.key === "k")) { e.preventDefault(); S.kbd = true; if (S.compare) return; step(-1); return; }
  if (e.key === "Enter" && typing && tag === "INPUT") { const id = S.cursor && rowsCache.some(x => x.id === S.cursor) ? S.cursor : rowsCache[0]?.id; if (id) { e.preventDefault(); e.target.blur(); setHash(`f-${S.col}-${id}`); } return; }
  if (typing) return;
  if (e.key === "Enter" && S.cursor && !S.open) { if (!document.activeElement?.closest?.(".row,.brow")) setHash(`f-${S.col}-${S.cursor}`); return; }
  if (e.key === "c" && (S.open?.id || S.cursor)) { togglePick(S.open?.id || S.cursor); return; }
});
document.addEventListener("pointermove", e => {
  const g = e.target.closest?.(".pt");
  if (g) { if (S._hot !== g.dataset.id) { S._hot = g.dataset.id; document.querySelectorAll(".pt.hot").forEach(x => x.classList.remove("hot")); g.classList.add("hot"); showTip(g.dataset.id); } }
  else if (S._hot) { S._hot = null; document.querySelectorAll(".pt.hot").forEach(x => x.classList.remove("hot")); const tip = $("#tip"); if (tip) tip.hidden = true; }
  const r = e.target.closest?.(".row");
  if (r && S.view === "map") { const n = S._pts?.get(r.dataset.id); if (S._rowhot !== r.dataset.id) { S._rowhot = r.dataset.id; document.querySelectorAll(".pt.hot").forEach(x => x.classList.remove("hot")); n?.classList.add("hot"); } }
  else if (!r && S._rowhot) { S._rowhot = null; if (!g) document.querySelectorAll(".pt.hot").forEach(x => x.classList.remove("hot")); }
}, { passive: true });
{
  const gt = $("#gtip"); let cur = null;
  const hide = () => { cur = null; gt.hidden = true; };
  const show = el => {
    if (el === cur) return; cur = el;
    gt.textContent = el.dataset.tip; gt.hidden = false;
    const r = el.getBoundingClientRect(), w = gt.offsetWidth, h = gt.offsetHeight;
    gt.style.left = Math.max(8, Math.min(innerWidth - w - 8, r.left + r.width / 2 - w / 2)) + "px";
    gt.style.top = (r.top - h - 6 < 8 ? r.bottom + 6 : r.top - h - 6) + "px";
  };
  document.addEventListener("pointerover", e => { const el = e.target.closest?.("[data-tip]"); if (el) show(el); else hide(); }, { passive: true });
  document.addEventListener("focusin", e => { const el = e.target.closest?.("[data-tip]"); if (el) show(el); else hide(); });
  addEventListener("scroll", hide, { passive: true, capture: true });
}
document.addEventListener("click", e => { const g = e.target.closest?.(".pt"); if (g) setHash(`f-${S.col}-${g.dataset.id}`); });

let rAF = 0;
const relayout = () => { cancelAnimationFrame(rAF); rAF = requestAnimationFrame(() => { if (S.view === "map" && !S.compare && $("#map")) { renderMap(filtered(S.col)); } }); };
const syncBar = () => { const b = $("#bar"); if (b) document.documentElement.style.setProperty("--bar-h", (narrow.matches ? ($(".topnav")?.offsetHeight || 0) : b.offsetHeight) + "px"); };
if ("ResizeObserver" in window) new ResizeObserver(() => { relayout(); syncBar(); }).observe($("#main")); else addEventListener("resize", () => { relayout(); syncBar(); });
narrow.addEventListener?.("change", () => { mode = ""; render(); });
addEventListener("hashchange", route);

/* Démarrage */
$("#brand").textContent = CFG.title;
applyTheme();
hydrate();
window.__atlas = { COLS, ficheBody, compareHtml, S };
route();
</script>
</body></html>
