import type { FastifyInstance } from "fastify";

export async function registerEssenceRoutes(app: FastifyInstance) {
  // GET /essence/random (аналог getesemus.php)
  app.get("/essence/random", async () => {
    // TODO: вернуть «эссенцию» трека (короткий отрывок / подборка)
    return {
      id: "ess-demo",
      name: "Essence demo track",
      artist: "Demo artist"
    };
  });

  // GET /jem/random (аналог getjemmus.php)
  app.get("/jem/random", async () => {
    // TODO: вернуть строку/ид трека для «жемчуга»
    return "jem-demo-id";
  });
}


