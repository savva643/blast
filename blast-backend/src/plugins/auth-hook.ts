import type { FastifyInstance, FastifyRequest, FastifyReply } from "fastify";

export async function registerAuthHook(app: FastifyInstance) {
  app.decorate(
    "authenticate",
    async (request: FastifyRequest, reply: FastifyReply) => {
      await request.jwtVerify();
      const payload = request.user as any;
      if (!payload.globalId && payload.sub !== undefined) {
        payload.globalId = String(payload.sub);
      }
    }
  );
}


