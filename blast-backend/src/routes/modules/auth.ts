import type { FastifyInstance, FastifyRequest } from "fastify";

interface LoginBody {
  login: string;
  password: string;
}

interface RegisterBody {
  login: string;
  password: string;
  email: string;
  nickname?: string;
}

export async function registerAuthRoutes(app: FastifyInstance) {
  // POST /auth/login  (аналог anlog.php)
  app.post(
    "/auth/login",
    async (request: FastifyRequest<{ Body: LoginBody }>, reply) => {
      const { login, password } = request.body;

      // TODO: взять пользователя из PostgreSQL (таблица users), проверить пароль (bcrypt)
      // Пример структуры ответа, как сейчас делает PHP anlog.php
      const isValid = false;

      if (!isValid) {
        return reply.code(401).send({
          status: "false",
          token: "no",
          froz: "no",
          rdel: "no",
          del: "no",
          ban: "no"
        });
      }

      const userId = 1;
      const token = await app.jwt.sign({ sub: userId, login });

      return {
        status: "true",
        token,
        froz: "no",
        rdel: "no",
        del: "no",
        ban: "no"
      };
    }
  );

  // POST /auth/register  (аналог anreg.php, пока только заглушка)
  app.post(
    "/auth/register",
    async (request: FastifyRequest<{ Body: RegisterBody }>, reply) => {
      const { login, password, email, nickname } = request.body;

      // TODO: создать запись в PostgreSQL (users), хешировать пароль, выдать jwt
      const userId = 1;
      const token = await app.jwt.sign({ sub: userId, login });

      return reply.code(201).send({
        status: "true",
        token,
        user: {
          id: userId,
          login,
          email,
          nickname
        }
      });
    }
  );
}


