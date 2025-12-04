## blast-database (черновая БД для Blast)

Эта папка предназначена для хранения SQL‑дампов и инициализационных скриптов, связанных **только с музыкальным сервисом blast** (без Necsoura Auth и общих профилей).

### Структура

- `init.sql` — главный скрипт инициализации PostgreSQL для blast.
- `schema-blast-core.sql` — структура таблиц, которые использует музыкальный backend.
- `data-blast-core.sql` — дамп данных этих таблиц (опционально, можно держать только структуру).

Ты можешь добавлять сюда дополнительные файлы, например:

- `schema-blast-extra.sql` — дополнительные таблицы blast, если появятся.
- `migrations/*.sql` — миграции для будущих версий.

### Что должно быть внутри (минимум для работы backend-node)

В `schema-blast-core.sql` должны быть DDL для таблиц:

- `music`
- `musartist`
- `albummusic`
- `videos`
- `memmusic`
- `memalbum`
- `musstory`
- `ischartview`
- `playlistmus`
- `playlistmuauser`
- `blastdevices`

И **отдельно**, в другой БД/схеме, будет таблица `kompot_profiles`, которую использует `/user/me`. Её можно оформить в другом SQL‑файле, чтобы не мешать её с чисто музыкальными таблицами, если хочешь.


