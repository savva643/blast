import "fastify";
import "@fastify/jwt";

declare module "fastify" {
  interface FastifyInstance {
    authenticate: any;
  }

  interface FastifyRequest {
    user: {
      globalId?: string;
      login?: string;
      type?: string;
      sub?: string | number;
    };
  }
}

declare module "@fastify/jwt" {
  interface FastifyJWT {
    payload: {
      globalId?: string;
      login?: string;
      type?: string;
      sub?: string | number;
    };
    user: {
      globalId?: string;
      login?: string;
      type?: string;
      sub?: string | number;
    };
  }
}



