import type { FastifyInstance, FastifyRequest } from "fastify";

export async function registerRecognitionRoutes(app: FastifyInstance) {
  // POST /recognize  (аналог recognize.php)
  app.post(
    "/recognize",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest) => {
      const data = await (request as any).file();
      // data.fieldname === 'audio'

      // TODO: сохранить временный файл, отдать его в сервис распознавания (например, сторонний API или свой ML),
      // затем вернуть структуру, схожую с текущим PHP:
      // { name, message, img, idshaz, url, doi, ... }

      void data;

      return {
        name: "Recognized track demo",
        message: "Demo artist",
        img: "https://kompot.keep-pixel.ru/img/music.jpg",
        idshaz: "demo-id",
        url: "https://cdn.example.com/blast/demo.m3u8",
        doi: "2"
      };
    }
  );
}


