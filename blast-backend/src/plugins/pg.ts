import type { FastifyInstance } from "fastify";
import pg from "pg";
import { env } from "../config/env.js";

declare module "fastify" {
  interface FastifyInstance {
    // тип намеренно ослаблен, чтобы не требовать деклараций pg
    pg: any;
  }
}

export async function registerPg(app: FastifyInstance) {
  const PgModule: any = pg as any;

  const pool = new PgModule.Pool({
    host: env.pg.host,
    port: env.pg.port,
    user: env.pg.user,
    password: env.pg.password,
    database: env.pg.database
  });

  app.decorate("pg", pool);

  app.addHook("onClose", async () => {
    await pool.end();
  });
}

