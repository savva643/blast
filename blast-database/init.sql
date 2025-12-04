-- init.sql — главный скрипт для поднятия PostgreSQL под blast
--
-- Запускается так (из psql):
--   \i blast-database/init.sql
--
-- ВНИМАНИЕ: здесь только база для музыкального backend-а blast.
-- Necsoura Auth и общие профили (necsoura_users, user_sessions и т.п.)
-- настраиваются отдельно и сюда не входят.

-- 1) Основные таблицы blast (музыка, плейлисты, история, устройства)
\i blast-database/schema-blast-core.sql

-- 2) Данные (если нужны тестовые данные или перенос с MySQL)
-- Можно закомментировать, если хочешь поднять пустую схему.
\i blast-database/data-blast-core.sql

-- 3) Дополнительные SQL-скрипты (по мере появления)
-- \i blast-database/schema-blast-extra.sql
-- \i blast-database/data-blast-extra.sql


