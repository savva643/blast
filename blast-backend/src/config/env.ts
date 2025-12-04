import dotenv from "dotenv";

dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV ?? "development",
  port: Number(process.env.PORT ?? 4000),

  // PostgreSQL (users, auth, billing)
  pg: {
    host: process.env.PG_HOST ?? "localhost",
    port: Number(process.env.PG_PORT ?? 5432),
    user: process.env.PG_USER ?? "blast",
    password: process.env.PG_PASSWORD ?? "blast",
    database: process.env.PG_DATABASE ?? "blast"
  },

  // MongoDB (tracks, playlists, histories, recommendations metadata)
  mongo: {
    uri: process.env.MONGO_URI ?? "mongodb://localhost:27017/blast"
  },

  // Redis (sessions, cache)
  redis: {
    url: process.env.REDIS_URL ?? "redis://localhost:6379"
  },

  // Elasticsearch (search)
  elastic: {
    node: process.env.ELASTIC_NODE ?? "http://localhost:9200",
    indexTracks: process.env.ELASTIC_INDEX_TRACKS ?? "blast_tracks"
  },

  // JWT
  jwtSecret: process.env.JWT_SECRET ?? "dev-secret-change-me",

  // Streaming / storage
  media: {
    // Root path or bucket for master audio files
    audioRoot: process.env.AUDIO_ROOT ?? "/var/blast/audio",
    // Public base URL for CDN where HLS segments are served
    cdnBaseUrl: process.env.CDN_BASE_URL ?? "https://cdn.example.com/blast"
  }
};


