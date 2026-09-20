# Tasbeeh SQLite bundle

Copy `databaseV1.db` from the private reference repo [Tasbeeh-Al-Muslim](https://github.com/AbdoAnany/Tasbeeh-Al-Muslim) (`assets/db/databaseV1.db`, ~7 MB) into this folder before release builds.

The app ships with JSON fallbacks (`assets/data/tasbeeh_portable.json`, `assets/data/zeker_seed.json`) so development and CI analyze/build without the binary database. When the DB file is present, hadith, duas, day azkar, Islamic events, and audio dhikr catalogs load from SQLite (Tasbeeh schema).

Also copy Android `res/raw/a*.mp3` sound assets from Tasbeeh for per-dhikr notification audio (documented in PR).
