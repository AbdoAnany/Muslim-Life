# Tasbeeh SQLite bundle

`databaseV1.db` (~7 MB) is included from the locked reference [Tasbeeh-Al-Muslim](https://github.com/AbdoAnany/Tasbeeh-Al-Muslim) (`assets/db/databaseV1.db`).

When present, hadith, duas, day azkar, Islamic events, and audio dhikr catalogs load from SQLite (Tasbeeh schema). JSON fallbacks under `assets/data/` remain for environments without the binary.

Android per-dhikr notification audio: `android/app/src/main/res/raw/a*.mp3` (copied from Tasbeeh).
