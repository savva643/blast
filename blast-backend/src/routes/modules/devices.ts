import type { FastifyInstance, FastifyRequest } from "fastify";

interface DeviceCreateBody {
  ip: string;
  name: string;
  os: string;
}

const getUserIdentifier = (request: FastifyRequest) =>
  (request.user as any)?.globalId ?? (request.user as any)?.sub;

export async function registerDeviceRoutes(app: FastifyInstance) {
  // GET /devices (аналог getdeviceblast.php?getdevices=token)
  app.get(
    "/devices",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest) => {
      const userId = getUserIdentifier(request);
      void userId;

      // TODO: взять список устройств пользователя из MongoDB/PostgreSQL
      return [
        {
          id: "dev1",
          name: "My PC",
          ip: "192.168.0.10",
          os: "windows"
        }
      ];
    }
  );

  // POST /devices (аналог getdeviceblast.php?createip=...)
  app.post(
    "/devices",
    {
      preHandler: [app.authenticate as any]
    },
    async (request: FastifyRequest<{ Body: DeviceCreateBody }>, reply) => {
      const userId = getUserIdentifier(request);
      const { ip, name, os } = request.body;

      void userId;
      void ip;
      void name;
      void os;

      // TODO: сохранить устройство и вернуть его id
      return reply.code(201).send({
        id: "dev1"
      });
    }
  );
}


