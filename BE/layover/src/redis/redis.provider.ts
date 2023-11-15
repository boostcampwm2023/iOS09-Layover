import { createClient } from 'redis';

export const redisProvider = [
  {
    provide: 'REDIS_CLIENT',
    useFactory: async (): Promise<ReturnType<typeof createClient>> => {
      const client = await createClient({
        url: `redis://${process.env.REDIS_USERNAME}:${process.env.REDIS_PASSWORD}@${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`,
      })
        .on('error', (err) => console.log('Redis Client Error', err))
        .connect();
      return client;
    },
  },
];