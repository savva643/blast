import type { FastifyInstance } from "fastify";
import { Client as ElasticClient } from "elasticsearch";
import { env } from "../config/env.js";

declare module "fastify" {
  interface FastifyInstance {
    elastic: ElasticClient;
  }
}

export async function registerElastic(app: FastifyInstance) {
  const client = new ElasticClient({
    host: env.elastic.node
  });

  app.decorate("elastic", client);

  app.addHook("onClose", async () => {
    await client.close();
  });
}


