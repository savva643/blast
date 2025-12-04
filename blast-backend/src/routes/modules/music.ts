import type { FastifyInstance, FastifyRequest } from "fastify";

interface TopQuery {
  lim?: number;
}

interface TrackByIdParams {
  id: string;
}

interface FavoritesQuery {
  count?: number;
}

const getUserIdentifier = (request: FastifyRequest) =>
  (request.user as any)?.globalId ?? (request.user as any)?.sub;

export async function registerMusicRoutes(app: FastifyInstance) {
  // GET /music/top?lim=20 (аналог gettopmusic.php)
  app.get(
    "/music/top",
    async (request: FastifyRequest<{ Querystring: TopQuery }>) => {
      const { lim = 20 } = request.query;

      // TODO: брать топ треков из MongoDB (коллекция tracks) по views или score
      // Сейчас PHP возвращает массив вида [ [ {track}, ... ], randomId ]
      return [
        [
          {
            id: 1,
            img: "https://kompot.keep-pixel.ru/music/400/demo.jpg",
            name: "Demo track",
            message: "Demo artist",
            url: "https://cdn.example.com/blast/demo.m3u8",
            elir: 0,
            doi: "2",
            idshaz: "demo-id",
            vidos: "0",
            bgvideo: "0",
            txt: "",
            likes: 0,
            dislikes: 0,
            timeurl: 0,
            short: "https://cdn.example.com/blast/demo-short.mp4",
            messageimg: "https://kompot.keep-pixel.ru/img/music.jpg"
          }
        ],
        1
      ].slice(0, Number(lim)); // временный пример
    }
  );

  // GET /music/favorites?count=... (аналог getlovemus.php)
  app.get(
    "/music/favorites",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest<{ Querystring: FavoritesQuery }>) => {
      const userId = getUserIdentifier(request);
      const { count = 0 } = request.query;

      // TODO: вытащить liked треки пользователя из MongoDB (коллекция favorites) или PostgreSQL
      // Сейчас PHP возвращает [ [ tracks... ] ]
      void userId;
      void count;

      return [
        [
          {
            id: 1,
            img: "https://kompot.keep-pixel.ru/music/400/demo.jpg",
            name: "Favorite demo",
            message: "Demo artist",
            url: "https://cdn.example.com/blast/demo.m3u8",
            elir: 0,
            doi: "1",
            idshaz: "demo-id",
            vidos: "0",
            txt: "",
            likes: 0,
            dislikes: 0,
            timeurl: 0,
            short: "https://cdn.example.com/blast/demo-short.mp4",
            messageimg: "https://kompot.keep-pixel.ru/img/music.jpg"
          }
        ]
      ];
    }
  );

  // GET /music/batch?ids=1,2,3 (аналог getaboutmus.php c sidis=...)
  app.get(
    "/music/batch",
    async (request: FastifyRequest<{ Querystring: { ids: string } }>) => {
      const { ids } = request.query;
      const list = ids.split(",").map((id) => id.trim());

      // TODO: найти треки по списку sid в Mongo
      void list;

      return [
        {
          id: 1,
          idshaz: "demo-id",
          name: "Demo track",
          message: "Demo artist",
          img: "https://kompot.keep-pixel.ru/music/400/demo.jpg",
          url: "https://cdn.example.com/blast/demo.m3u8"
        }
      ];
    }
  );

  // GET /music/:id (аналог getaboutmus.php)
  app.get(
    "/music/:id",
    async (request: FastifyRequest<{ Params: TrackByIdParams }>) => {
      const { id } = request.params;

      // TODO: найти трек по id или sid (idshaz) в Mongo
      void id;

      return {
        id: 1,
        idshaz: "demo-id",
        name: "Demo track",
        message: "Demo artist",
        img: "https://kompot.keep-pixel.ru/music/400/demo.jpg",
        url: "https://cdn.example.com/blast/demo.m3u8"
      };
    }
  );

  // POST /music/:id/reaction (аналог reactmusic.php)
  app.post(
    "/music/:id/reaction",
    {
      preHandler: [app.authenticate as any]
    },
    async (
      request: FastifyRequest<{
        Params: TrackByIdParams;
        Body: { type: number };
      }>
    ) => {
      const userId = getUserIdentifier(request);
      const { id } = request.params;
      const { type } = request.body;

      // TODO: сохранить реакцию (like/dislike) в Mongo/Postgres, обновить счетчики, вернуть новый type
      void userId;
      void id;
      void type;

      return {
        status: "true",
        type: "1"
      };
    }
  );

  // POST /music/:id/install (аналог installmusapple.php)
  app.post(
    "/music/:id/install",
    {
      preHandler: [app.authenticate as any]
    },
    async (
      request: FastifyRequest<{
        Params: TrackByIdParams;
      }>
    ) => {
      const userId = getUserIdentifier(request);
      const { id } = request.params;

      void userId;
      void id;

      // TODO: отметить трек как загруженный / выдать ссылку для скачивания
      return {
        status: "queued"
      };
    }
  );
}


