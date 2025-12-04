import type { FastifyInstance } from "fastify";
import mongoist, { type Db } from "mongoist";
import { env } from "../config/env.js";

declare module "fastify" {
  interface FastifyInstance {
    mongo: Db;
  }
}

export async function registerMongo(app: FastifyInstance) {
  const db = mongoist(env.mongo.uri);

  app.decorate("mongo", db);

  app.addHook("onClose", async () => {
    await db.close();
  });
}


