#!/usr/bin/env python3
"""Build assets/data/tafsir_ar.json from spa5k/tafsir_api (ar-tafsir-muyassar)."""
import json
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE = "https://cdn.jsdelivr.net/gh/spa5k/tafsir_api@main/tafsir/ar-tafsir-muyassar"
ATTRIBUTION = (
    "التفسير الميسر (Muyassar). Source: spa5k/tafsir_api edition ar-tafsir-muyassar "
    "(QUL / Quranic Universal Library). API data MIT License (c) 2023 Spark. "
    "Tafsir text is from the official Muyassar edition; verify publisher terms for redistribution."
)


def fetch_surah(n: int) -> tuple[int, list]:
    url = f"{BASE}/{n}.json"
    with urllib.request.urlopen(url, timeout=120) as resp:
        return n, json.loads(resp.read().decode("utf-8"))


def main() -> None:
    out: dict = {"attribution": ATTRIBUTION}
    total_ayahs = 0
    with ThreadPoolExecutor(max_workers=8) as ex:
        futures = [ex.submit(fetch_surah, s) for s in range(1, 115)]
        by_surah: dict[int, list] = {}
        for fut in as_completed(futures):
            surah_num, entries = fut.result()
            by_surah[surah_num] = entries

    for surah_num in range(1, 115):
        entries = by_surah[surah_num]
        surah_map: dict[str, str] = {}
        for entry in entries:
            ayah = entry["ayah"]
            text = (entry.get("text") or "").strip()
            surah_map[str(ayah)] = text
            total_ayahs += 1
        out[str(surah_num)] = surah_map

    assert len(by_surah) == 114, f"expected 114 surahs, got {len(by_surah)}"
    assert total_ayahs == 6236, f"expected 6236 ayahs, got {total_ayahs}"

    path = "assets/data/tafsir_ar.json"
    with open(path, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, separators=(",", ":"))

    import os

    size_mb = os.path.getsize(path) / (1024 * 1024)
    print(f"Wrote {path}: {total_ayahs} ayahs, {size_mb:.2f} MB")


if __name__ == "__main__":
    main()
