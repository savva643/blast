import type { FastifyInstance, FastifyRequest, FastifyReply } from "fastify";

const DEFAULT_AVATAR = "https://bladt.keep-pixel.ru/static/img/music.jpg";

const getUserIdentifier = (request: FastifyRequest) =>
  (request.user as any)?.globalId ?? (request.user as any)?.sub;

export async function registerUserRoutes(app: FastifyInstance) {
  app.get(
    "/user/me",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const globalId = getUserIdentifier(request);

      if (!globalId) {
        return reply.status(401).send({
          status: "false",
          message: "Некорректный токен"
        });
      }

      const result = await app.pg.query(
        `SELECT id,
                global_id,
                name,
                opic,
                img,
                background,
                username,
                location,
                job_title,
                favorite_song,
                social_links
           FROM kompot_profiles
          WHERE global_id = $1
          LIMIT 1`,
        [globalId]
      );

      if (result.rowCount === 0) {
        return reply.status(404).send({
          status: "false",
          message: "Профиль не найден"
        });
      }

      const profile = result.rows[0];
      let socialLinks: Array<{ label: string; url: string }> = [];

      if (profile.social_links) {
        try {
          const parsed = JSON.parse(profile.social_links);
          if (Array.isArray(parsed)) {
            socialLinks = parsed
              .filter(
                (item: any) =>
                  typeof item?.label === "string" && typeof item?.url === "string"
              )
              .map((item: any) => ({
                label: item.label,
                url: item.url
              }));
          }
        } catch {
          // игнорируем невалидный JSON
        }
      }

      return {
        status: "true",
        id: profile.id,
        globalId: profile.global_id,
        name: profile.name ?? "",
        username: profile.username ?? "",
        description: profile.opic ?? "",
        avatar: profile.img ?? DEFAULT_AVATAR,
        background: profile.background ?? "0",
        location: profile.location ?? "",
        jobTitle: profile.job_title ?? "",
        favoriteSong: profile.favorite_song ?? "",
        socialLinks
      };
    }
  );
}

