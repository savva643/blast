import type { FastifyInstance } from "fastify";

export async function registerVideoRoutes(app: FastifyInstance) {
  // GET /videos/top (аналог getvideomus.php)
  app.get("/videos/top", async () => {
    // TODO: брать данные из MongoDB (коллекция videos)
    return [
      {
        id: "vid1",
        title: "Demo video",
        img: "https://kompot.keep-pixel.ru/img/music.jpg",
        url: "https://cdn.example.com/blast/demo-video.m3u8"
      }
    ];
  });
}


