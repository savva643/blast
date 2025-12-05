import type { FastifyInstance } from "fastify";
import elasticsearch from "elasticsearch";
import { env } from "../config/env.js";

declare module "fastify" {
  interface FastifyInstance {
    // тип намеренно ослаблен, чтобы не требовать деклараций elasticsearch
    elastic: any;
  }
}

export async function registerElastic(app: FastifyInstance) {
  const ElasticClient: any = (elasticsearch as any).Client;

  const client = new ElasticClient({
    host: env.elastic.node
  });

  app.decorate("elastic", client);

  app.addHook("onClose", async () => {
    await client.close();
  });
}

