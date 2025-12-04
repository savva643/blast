import type { FastifyInstance, FastifyRequest } from "fastify";

interface SearchQuery {
  q: string;
  limit?: number;
}

export async function registerSearchRoutes(app: FastifyInstance) {
  // GET /search/tracks?q=... (аналог getmusshazandr.php + расширенный поиск)
  app.get(
    "/search/tracks",
    async (request: FastifyRequest<{ Querystring: SearchQuery }>) => {
      const { q, limit = 20 } = request.query;

      // TODO: запрос к Elasticsearch по индексу треков
      const { hits } = await app.elastic.search({
        index: "blast_tracks",
        body: {
          query: {
            multi_match: {
              query: q,
              fields: ["title^3", "artist^2", "album", "tags"]
            }
          },
          size: limit
        }
      });

      return hits.hits.map((hit: any) => ({
        id: hit._source.id,
        name: hit._source.title,
        message: hit._source.artist,
        img: hit._source.coverUrl,
        url: hit._source.streamUrl
      }));
    }
  );
}


