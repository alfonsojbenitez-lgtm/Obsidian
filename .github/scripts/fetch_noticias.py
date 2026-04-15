#!/usr/bin/env python3
"""
fetch_noticias.py — Resumen diario de noticias económicas y de cartera
Genera una nota Obsidian en proyectos/Inversiones/noticias/YYYY-MM-DD.md
"""

import os
import sys
from datetime import date, datetime, timezone, timedelta

import feedparser
import yfinance as yf
import anthropic

# ── Cartera ────────────────────────────────────────────────────────────────────
PORTFOLIO = {
    "AZJ":  {"name": "Aurizon Holdings",        "yahoo": "AZJ.AX",  "sector": "Industrial"},
    "JIN":  {"name": "Jumbo Interactive",        "yahoo": "JIN.AX",  "sector": "Entretenimiento"},
    "FDJU": {"name": "FDJ United",               "yahoo": "FDJU.PA", "sector": "Entretenimiento"},
    "HEN":  {"name": "Henkel AG",                "yahoo": "HEN.DE",  "sector": "Consumo básico"},
    "VIS":  {"name": "Viscofan",                 "yahoo": "VIS.MC",  "sector": "Consumo básico"},
    "WKL":  {"name": "Wolters Kluwer",           "yahoo": "WKL.AS",  "sector": "Tecnología"},
    "BNZL": {"name": "Bunzl PLC",                "yahoo": "BNZL.L",  "sector": "Industrial"},
    "DGE":  {"name": "Diageo PLC",               "yahoo": "DGE.L",   "sector": "Consumo básico"},
    "ITRK": {"name": "Intertek Group",           "yahoo": "ITRK.L",  "sector": "Industrial"},
    "REC":  {"name": "Record PLC",               "yahoo": "REC.L",   "sector": "Financiero"},
    "APLE": {"name": "Apple Hospitality REIT",   "yahoo": "APLE",    "sector": "REIT"},
    "COLD": {"name": "Americold Realty",         "yahoo": "COLD",    "sector": "REIT"},
    "GIS":  {"name": "General Mills",            "yahoo": "GIS",     "sector": "Consumo básico"},
    "IIPR": {"name": "Inn. Industrial Properties","yahoo": "IIPR",   "sector": "REIT"},
    "KHC":  {"name": "Kraft Heinz",              "yahoo": "KHC",     "sector": "Consumo básico"},
    "LYB":  {"name": "LyondellBasell",           "yahoo": "LYB",     "sector": "Materiales"},
    "RHI":  {"name": "Robert Half",              "yahoo": "RHI",     "sector": "Industrial"},
    "RICK": {"name": "RCI Hospitality",          "yahoo": "RICK",    "sector": "Entretenimiento"},
    "SWKS": {"name": "Skyworks Solutions",       "yahoo": "SWKS",    "sector": "Tecnología"},
    "TAP":  {"name": "Molson Coors",             "yahoo": "TAP",     "sector": "Consumo básico"},
    "TFX":  {"name": "Teleflex",                 "yahoo": "TFX",     "sector": "Salud"},
    "TROW": {"name": "T. Rowe Price",            "yahoo": "TROW",    "sector": "Financiero"},
}

# ── Fuentes RSS macro ──────────────────────────────────────────────────────────
RSS_FEEDS = [
    ("Reuters Business",   "https://feeds.reuters.com/reuters/businessNews"),
    ("CNBC Economy",       "https://search.cnbc.com/rs/search/combinedcms/view.xml?partnerId=wrss01&id=10000664"),
    ("MarketWatch",        "https://feeds.marketwatch.com/marketwatch/topstories/"),
    ("Yahoo Finance",      "https://finance.yahoo.com/news/rssindex"),
    ("Investing.com",      "https://www.investing.com/rss/news.rss"),
]

MESES_ES = {
    1: "enero", 2: "febrero", 3: "marzo", 4: "abril",
    5: "mayo", 6: "junio", 7: "julio", 8: "agosto",
    9: "septiembre", 10: "octubre", 11: "noviembre", 12: "diciembre",
}


# ── Fetch RSS ──────────────────────────────────────────────────────────────────
def fetch_rss_news(max_per_feed: int = 12) -> list[dict]:
    """Recoge titulares macro de las últimas 24h."""
    cutoff = datetime.now(timezone.utc) - timedelta(hours=26)
    headlines = []

    for source, url in RSS_FEEDS:
        try:
            feed = feedparser.parse(url, request_headers={"User-Agent": "Mozilla/5.0"})
            count = 0
            for entry in feed.entries:
                if count >= max_per_feed:
                    break
                # Filtrar por fecha si está disponible
                published = None
                if hasattr(entry, "published_parsed") and entry.published_parsed:
                    try:
                        published = datetime(*entry.published_parsed[:6], tzinfo=timezone.utc)
                    except Exception:
                        pass

                if published and published < cutoff:
                    continue

                title = getattr(entry, "title", "").strip()
                summary = getattr(entry, "summary", "").strip()
                # Limpiar HTML básico del summary
                summary = summary[:250].split("<")[0].strip()

                if title:
                    headlines.append({
                        "source": source,
                        "title": title,
                        "summary": summary,
                    })
                    count += 1

            print(f"  {source}: {count} titulares")
        except Exception as e:
            print(f"  ⚠ Error {source}: {e}", file=sys.stderr)

    return headlines


# ── Fetch ticker news ──────────────────────────────────────────────────────────
def fetch_ticker_news(max_per_ticker: int = 4) -> dict:
    """Noticias específicas por ticker via yfinance."""
    ticker_news = {}

    for ticker, info in PORTFOLIO.items():
        try:
            t = yf.Ticker(info["yahoo"])
            raw_news = t.news or []
            items = []

            for item in raw_news[:max_per_ticker]:
                # yfinance ≥0.2.x usa 'content' anidado en algunas versiones
                title = (
                    item.get("title")
                    or (item.get("content") or {}).get("title")
                    or ""
                ).strip()
                if title:
                    items.append(title)

            if items:
                ticker_news[ticker] = {"name": info["name"], "sector": info["sector"], "news": items}
        except Exception as e:
            print(f"  ⚠ Error {ticker}: {e}", file=sys.stderr)

    print(f"  Tickers con noticias: {len(ticker_news)}/{len(PORTFOLIO)}")
    return ticker_news


# ── Llamada a Claude ───────────────────────────────────────────────────────────
def generate_summary(macro_headlines: list, ticker_news: dict, today: date) -> str:
    """Usa Claude Haiku para generar el resumen en español."""
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise RuntimeError("ANTHROPIC_API_KEY no está configurado")

    client = anthropic.Anthropic(api_key=api_key)

    # Construir texto de entrada
    macro_text = "\n".join(
        f"- [{h['source']}] {h['title']}" + (f" — {h['summary']}" if h.get("summary") else "")
        for h in macro_headlines[:35]
    )

    ticker_lines = []
    for ticker, data in ticker_news.items():
        news_str = "\n".join(f"  • {n}" for n in data["news"])
        ticker_lines.append(f"{ticker} ({data['name']}, {data['sector']}):\n{news_str}")
    ticker_text = "\n\n".join(ticker_lines) if ticker_lines else "Sin noticias recogidas."

    fecha_str = f"{today.day} de {MESES_ES[today.month]} de {today.year}"
    tickers_cartera = ", ".join(PORTFOLIO.keys())

    prompt = f"""Eres analista de inversiones para un inversor value/dividendos español. Hoy es {fecha_str}.

Cartera: {tickers_cartera}

NOTICIAS MACRO (últimas 24h):
{macro_text}

NOTICIAS POR EMPRESA:
{ticker_text}

Genera un resumen diario en ESPAÑOL con este formato Markdown exacto (no uses otro):

## Resumen macro del día

[2-3 párrafos breves: contexto económico global, principales movimientos de mercado, datos macro publicados, política monetaria, aranceles/geopolítica si relevante]

## Noticias relevantes para la cartera

[Incluye SOLO las empresas con noticias materialmente relevantes: resultados trimestrales, cambios de dividendo, M&A, cambios de guidance, problemas regulatorios, movimientos sectoriales que les afecten directamente. Formato por empresa:
**TICKER — Nombre**: descripción breve de la noticia y su posible impacto]

## Sin noticias destacadas hoy

[Lista simple de los tickers sin noticias relevantes, en una sola línea separados por comas]

---
Sé conciso y directo. El inversor lee esto por la mañana antes de revisar su cartera. Prioriza señales de alerta y catalizadores, no ruido."""

    response = client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=1800,
        messages=[{"role": "user", "content": prompt}],
    )

    return response.content[0].text.strip()


# ── Crear nota Obsidian ────────────────────────────────────────────────────────
def create_obsidian_note(summary_content: str, today: date) -> str:
    date_str = today.strftime("%Y-%m-%d")
    date_display = f"{today.day} de {MESES_ES[today.month]} de {today.year}"
    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    return f"""---
title: "Noticias mercado — {date_str}"
tags:
  - inversiones
  - noticias
  - mercados
date: {date_str}
generado: automático
---

# Noticias de mercado — {date_display}

> [!info] Generado automáticamente · {generated_at}
> Resumen diario de noticias económicas y de mercado relevantes para la cartera.
> Fuentes: Reuters · CNBC · MarketWatch · Yahoo Finance · yfinance (por ticker)

{summary_content}

---

*[[cartera/Cartera actual|Ver cartera]] · [[noticias/|Historial de noticias]]*
"""


# ── Main ───────────────────────────────────────────────────────────────────────
def main():
    # Fecha: variable de entorno INPUT_FECHA (workflow_dispatch) o hoy
    fecha_input = os.environ.get("INPUT_FECHA", "").strip()
    if fecha_input:
        today = date.fromisoformat(fecha_input)
        print(f"Generando noticias para fecha: {today}")
    else:
        today = date.today()
        print(f"Generando noticias para hoy: {today}")

    output_path = f"proyectos/Inversiones/noticias/{today.isoformat()}.md"

    # No sobreescribir si ya existe (salvo ejecución manual)
    if os.path.exists(output_path) and not fecha_input:
        print(f"Ya existe {output_path} — nada que hacer")
        return

    print("\n1. Recogiendo noticias macro (RSS)...")
    macro_headlines = fetch_rss_news()
    print(f"   Total: {len(macro_headlines)} titulares")

    print("\n2. Recogiendo noticias por ticker (yfinance)...")
    ticker_news = fetch_ticker_news()

    print("\n3. Generando resumen con Claude Haiku...")
    summary = generate_summary(macro_headlines, ticker_news, today)

    print("\n4. Creando nota Obsidian...")
    note_content = create_obsidian_note(summary, today)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(note_content)

    print(f"\n✓ Nota guardada: {output_path}")
    print(f"  Caracteres: {len(note_content)}")


if __name__ == "__main__":
    main()
