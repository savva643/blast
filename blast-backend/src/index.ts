import Fastify from "fastify";
import cors from "@fastify/cors";
import multipart from "@fastify/multipart";
import fastifyJwt from "@fastify/jwt";
import fastifyRedis from "@fastify/redis";
import fastifyStatic from "@fastify/static";
import { join } from "node:path";

import { env } from "./config/env.js";
import { registerPg } from "./plugins/pg.js";
import { registerMongo } from "./plugins/mongo.js";
import { registerElastic } from "./plugins/elastic.js";
import { registerAuthHook } from "./plugins/auth-hook.js";
import { registerRoutes } from "./routes/index.js";

async function buildServer() {
  const app = Fastify({
    logger: true
  });

  await app.register(cors, {
    origin: true,
    credentials: true
  });

  await app.register(multipart);

  await app.register(fastifyJwt, {
    secret: env.jwtSecret
  });

  await app.register(fastifyRedis, {
    url: env.redis.url
  });

  // Static for HLS segments / images if you serve them from Node (optional, CDN is preferred)
  await app.register(fastifyStatic, {
    root: join(process.cwd(), "public"),
    prefix: "/static/"
  });

  await registerPg(app);
  await registerMongo(app);
  await registerElastic(app);
  await registerAuthHook(app);

  await registerRoutes(app);

  // Маршруты для статики / лендинга
  app.get("/", async (request, reply) => {
    return reply.type("text/html").sendFile("index.html");
  });

  app.get("/download", async (request, reply) => {
    return reply.type("text/html").sendFile("download.html");
  });

  app.get("/about", async (request, reply) => {
    return reply.type("text/html").sendFile("about.html");
  });

  app.get("/changelog", async (request, reply) => {
    return reply.type("text/html").sendFile("changelog.html");
  });

  return app;
}

async function main() {
  const app = await buildServer();

  try {
    await app.listen({ port: env.port, host: "0.0.0.0" });
    app.log.info(`Blast backend started on port ${env.port}`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

main();


