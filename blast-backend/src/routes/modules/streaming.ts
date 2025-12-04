import type { FastifyInstance, FastifyRequest } from "fastify";
import ffmpeg from "fluent-ffmpeg";
import ffmpegStatic from "ffmpeg-static";
import { createReadStream } from "node:fs";
import { join } from "node:path";
import { env } from "../../config/env.js";

interface StreamParams {
  trackId: string;
}

export async function registerStreamingRoutes(app: FastifyInstance) {
  ffmpeg.setFfmpegPath(ffmpegStatic as string);

  // GET /stream/:trackId  — HLS/live-поток для трека
  app.get(
    "/stream/:trackId",
    async (request: FastifyRequest<{ Params: StreamParams }>, reply) => {
      const { trackId } = request.params;

      // Вариант 1: уже подготовленный HLS на CDN
      // Вариант 2: on-the-fly транскодирование в HLS через FFmpeg
      // Здесь пример очень простой: отдаём файл как progressive stream.

      const filePath = join(env.media.audioRoot, `${trackId}.mp3`);

      reply.header("Content-Type", "audio/mpeg");
      const stream = createReadStream(filePath);
      return reply.send(stream);
    }
  );
}


