import type { FastifyInstance, FastifyRequest } from "fastify";

interface PlaylistParams {
  id: string;
}

interface PlaylistQuery {
  count?: number;
}

const getUserIdentifier = (request: FastifyRequest) =>
  (request.user as any)?.globalId ?? (request.user as any)?.sub;

export async function registerPlaylistRoutes(app: FastifyInstance) {
  // GET /playlists?count=... (аналог getmusicplaylist.php getplaylist)
  app.get(
    "/playlists",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest<{ Querystring: PlaylistQuery }>) => {
      const userId = getUserIdentifier(request);
      const { count = 50 } = request.query;

      void userId;
      void count;

      // TODO: читать плейлисты пользователя из MongoDB
      return [
        [
          {
            id: "pl1",
            name: "Мой плейлист",
            img: "https://kompot.keep-pixel.ru/img/music.jpg",
            tracksCount: 10
          }
        ]
      ];
    }
  );

  // GET /playlists/:id (аналог getmusfromplaylist.php)
  app.get(
    "/playlists/:id",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest<{ Params: PlaylistParams }>) => {
      const userId = getUserIdentifier(request);
      const { id } = request.params;

      void userId;
      void id;

      // TODO: вернуть треки конкретного плейлиста
      return [
        [
          {
            id: 1,
            name: "Demo track in playlist",
            img: "https://kompot.keep-pixel.ru/music/400/demo.jpg"
          }
        ]
      ];
    }
  );

  // GET /albums?count=... (аналог getmusicplaylist.php getalbum)
  app.get(
    "/albums",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest<{ Querystring: PlaylistQuery }>) => {
      const userId = getUserIdentifier(request);
      const { count = 50 } = request.query;

      void userId;
      void count;

      // TODO: читать альбомы пользователя или глобальные из MongoDB
      return [
        [
          {
            id: "al1",
            name: "Demo album",
            img: "https://kompot.keep-pixel.ru/img/music.jpg",
            tracksCount: 10
          }
        ]
      ];
    }
  );
}


