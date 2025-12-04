## Blast / Necsoura Backend (черновая документация)

Этот файл — вспомогательная дока для разработки backend-node. Основная документация проекта будет лежать в корне репозитория отдельно.

### Архитектура

- **API:** Node.js + TypeScript + Fastify (`backend-node`).
- **Auth:** внешний микросервис Necsoura (`auth.keep-pixel.ru`), маршруты `/api/auth/*`.
- **Музыка / плейлисты / история:** MongoDB.
- **Пользователи / профили Kompot:** PostgreSQL.
- **Поиск:** Elasticsearch.
- **Кеш:** Redis.
- **Статика / лендинг:** HTML из `backend-node/public` (отдаётся через Fastify Static и отдельные маршруты).

### Переменные окружения (из .env)

См. `.env.example` в `backend-node`. Критичные:

- `JWT_SECRET` — **должен совпадать** с `JWT_SECRET` микросервиса авторизации Necsoura.
- `PG_*` — подключение к PostgreSQL, где есть таблицы, в т.ч. `kompot_profiles`.
- `MONGO_URI`, `REDIS_URL`, `ELASTIC_NODE` — подключения к MongoDB, Redis и Elasticsearch.

### PostgreSQL: kompot_profiles

Таблица профилей Kompot в PostgreSQL должна быть создана по схеме:

```sql
CREATE TABLE kompot_profiles (
  id INT PRIMARY KEY,
  global_id VARCHAR(36) NOT NULL,
  name VARCHAR(250),
  opic VARCHAR(255),
  img TEXT,
  background VARCHAR(255) NOT NULL DEFAULT '0',
  username VARCHAR(50),
  location VARCHAR(255),
  job_title VARCHAR(255),
  favorite_song VARCHAR(255),
  social_links TEXT
);
```

- `global_id` — совпадает с `globalId` из JWT Necsoura (и пользователя в `necsoura_users`).
- `img` и другие медиа-поля должны содержать уже готовые URL (CDN или статику, которую отдаёт Fastify).

### JWT и аутентификация

- Микросервис авторизации Necsoura выдаёт JWT с полями:
  - `globalId`, `login`, `type` (`access` / `refresh`).
- Fastify (`backend-node`) использует `@fastify/jwt` и плагин `auth-hook`, который:
  - проверяет подпись токена;
  - прокидывает `request.user.globalId` во все защищённые обработчики.

Все защищённые маршруты используют `preHandler: [app.authenticate]` и получают идентификатор пользователя через:

```ts
const userId = (request.user as any)?.globalId ?? (request.user as any)?.sub;
```

### Маршруты API (основные)

- `GET /user/me` — профиль пользователя по `globalId` (данные из `kompot_profiles`).
- `GET /music/top`, `/music/favorites`, `/music/:id`, `/music/batch`.
- `POST /music/:id/reaction`, `POST /music/:id/install`.
- `GET /playlists`, `/playlists/:id`, `/albums`.
- `GET /videos/top`, `/essence/random`, `/jem/random`.
- `GET /devices`, `POST /devices`.
- `GET /search/tracks`.
- `GET /stream/:trackId`.
- `POST /recognize`.

### Статические страницы

- Файлы статики лежат в `backend-node/public`:
  - `index.html`, `download.html`, `about.html`, `changelog.html`.
- Fastify Static отдаёт `/static/*` (иконки/картинки и т.п.).
- Отдельные маршруты мапятся на HTML:
  - `/` → `index.html`
  - `/download` → `download.html`
  - `/about` → `about.html`
  - `/changelog` → `changelog.html`

В дальнейшем старый PHP-фронтенд (`blast-frontend/*.php`) можно удалить — все страницы станут чистым HTML, отданным через Node.js.


