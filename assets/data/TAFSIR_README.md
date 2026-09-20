# Offline Arabic tafsir (التفسير الميسر)

## Bundled file

- **Path:** `assets/data/tafsir_ar.json`
- **Edition:** التفسير الميسر (Tafsir al-Muyassar)
- **Coverage:** 114 surahs, 6236 ayahs (full Quran)
- **Approx. size:** ~2.7 MB (uncompressed JSON)

## JSON shape (app contract)

```json
{
  "attribution": "…",
  "1": { "1": "…", "2": "…" },
  "2": { "1": "…" }
}
```

Surah and ayah keys are decimal strings. The Quran reader strips `attribution` at load time and looks up tafsir by surah number and ayah-in-surah number.

## Source

Data is taken from the [spa5k/tafsir_api](https://github.com/spa5k/tafsir_api) project, edition **`ar-tafsir-muyassar`**, served from:

`https://cdn.jsdelivr.net/gh/spa5k/tafsir_api@main/tafsir/ar-tafsir-muyassar/{surah}.json`

Each surah file is an array of `{ "surah", "ayah", "text" }` objects aligned with standard Uthmani numbering.

## License and attribution

- The **tafsir_api** repository is under the **MIT License** (Copyright (c) 2023 Spark). See [LICENSE](https://github.com/spa5k/tafsir_api/blob/main/LICENSE).
- The **Muyassar** tafsir text itself is an established published edition; this app bundles it for offline reading only. The in-app `attribution` field in `tafsir_ar.json` repeats the source and license notice for developers.

## Regenerating the asset

From the repo root (requires network):

```bash
python3 scripts/build_tafsir_ar.py
```

Commit the updated `assets/data/tafsir_ar.json` if the upstream export changes.
