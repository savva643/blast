import type { FastifyInstance } from "fastify";
import { registerUserRoutes } from "./modules/users.js";
import { registerMusicRoutes } from "./modules/music.js";
import { registerPlaylistRoutes } from "./modules/playlists.js";
import { registerDeviceRoutes } from "./modules/devices.js";
import { registerSearchRoutes } from "./modules/search.js";
import { registerStreamingRoutes } from "./modules/streaming.js";
import { registerRecognitionRoutes } from "./modules/recognition.js";
import { registerVideoRoutes } from "./modules/videos.js";
import { registerEssenceRoutes } from "./modules/essence.js";

export async function registerRoutes(app: FastifyInstance) {
  app.get("/health", async () => ({ status: "ok" }));

  // Публичные страницы
  app.get("/", async (_request, reply) => reply.sendFile("index.html"));
  app.get("/download", async (_request, reply) => reply.sendFile("download.html"));
  app.get("/about", async (_request, reply) => reply.sendFile("about.html"));
  app.get("/changelog", async (_request, reply) => reply.sendFile("changelog.html"));

  // Auth теперь отдан отдельному микросервису auth.keep-pixel.ru,
  // так что локальные auth-роуты можно не использовать.
  await registerUserRoutes(app);
  await registerMusicRoutes(app);
  await registerPlaylistRoutes(app);
  await registerDeviceRoutes(app);
  await registerSearchRoutes(app);
  await registerStreamingRoutes(app);
  await registerRecognitionRoutes(app);
  await registerVideoRoutes(app);
  await registerEssenceRoutes(app);
}


