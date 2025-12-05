import type { FastifyInstance } from "fastify";
import { MongoClient, type Db } from "mongodb";
import { env } from "../config/env.js";

declare module "fastify" {
  interface FastifyInstance {
    mongo: Db;
  }
}

export async function registerMongo(app: FastifyInstance) {
  const client = new MongoClient(env.mongo.uri);
  await client.connect();

  const db = client.db(); // берём БД из URI (например, mongodb://host:27017/blast)

  app.decorate("mongo", db);

  app.addHook("onClose", async () => {
    await client.close();
  });
}

