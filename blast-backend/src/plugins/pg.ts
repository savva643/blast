import type { FastifyInstance } from "fastify";
import pg from "pg";
import { env } from "../config/env.js";

declare module "fastify" {
  interface FastifyInstance {
    pg: pg.Pool;
  }
}

export async function registerPg(app: FastifyInstance) {
  const pool = new pg.Pool({
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


