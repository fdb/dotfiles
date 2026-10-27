# /// script
# requires-python = ">=3.11"
# dependencies = ["playwright>=1.47"]
# ///
"""Run measure.js against a URL or local file and print the report.

uv run measure.py http://localhost:5173/dashboard
uv run measure.py page.html --root main --screenshot before.png
uv run measure.py URL --compare before.json     # print the change per metric

Uses the installed Google Chrome; without it, run once: uvx playwright install chromium
"""
import argparse
import json
import pathlib
import sys

from playwright.sync_api import sync_playwright

HERE = pathlib.Path(__file__).resolve().parent


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("target", help="URL or path to an HTML file")
    ap.add_argument("--root", help="CSS selector to measure inside (default: body)")
    ap.add_argument("--width", type=int, default=1280)
    ap.add_argument("--height", type=int, default=900)
    ap.add_argument("--dark", action="store_true", help="emulate prefers-color-scheme: dark")
    ap.add_argument("--before-js", help="JavaScript to run before measuring, e.g. to open a menu or pick a tab")
    ap.add_argument("--screenshot", help="write a full-page PNG here")
    ap.add_argument("--out", help="write the JSON report here")
    ap.add_argument("--compare", help="earlier JSON report; prints the delta of each summary metric")
    ap.add_argument("--full", action="store_true", help="print detail as well as summary")
    a = ap.parse_args()

    target = a.target
    if "://" not in target:
        target = pathlib.Path(target).resolve().as_uri()
    src = (HERE / "measure.js").read_text()

    with sync_playwright() as p:
        try:
            browser = p.chromium.launch(channel="chrome")
        except Exception:
            browser = p.chromium.launch()
        page = browser.new_page(
            viewport={"width": a.width, "height": a.height},
            color_scheme="dark" if a.dark else "light",
        )
        page.goto(target, wait_until="networkidle")
        page.evaluate("document.fonts && document.fonts.ready")
        if a.before_js:
            page.evaluate(a.before_js)
            page.wait_for_timeout(200)
        report = page.evaluate(f"({src})({json.dumps({'root': a.root} if a.root else {})})")
        if a.screenshot:
            page.screenshot(path=a.screenshot, full_page=True)
        browser.close()

    if "error" in report:
        print(report["error"], file=sys.stderr)
        return 1
    if a.out:
        pathlib.Path(a.out).write_text(json.dumps(report, indent=2))

    if a.compare:
        before = json.loads(pathlib.Path(a.compare).read_text())["summary"]
        width = max(map(len, report["summary"]))
        for k, v in report["summary"].items():
            b = before.get(k)
            delta = "" if b is None or b == v else f"  ({b} → {v})"
            print(f"{k:<{width}}  {v}{delta}")
    else:
        print(json.dumps(report if a.full else report["summary"], indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
