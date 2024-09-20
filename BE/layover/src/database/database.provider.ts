import { DataSource } from 'typeorm';

export const databaseProviders = [
  {
    provide: 'DATA_SOURCE', // 둘 이상의 provider가 있으면 얘로 구분됨. 따로 작성하지 않으면 class 이름이 provider 키가 됨.
    useFactory: async () => {
      const dataSource = new DataSource({
        type: 'mysql',
        host: process.env.MYSQL_HOST,
        port: Number(process.env.MYSQL_PORT),
        username: process.env.MYSQL_USERNAME,
        password: process.env.MYSQL_PASSWORD,
        database: 'layover_test',
        entities: [__dirname + '/../**/*.entity{.ts,.js}'],
        synchronize: true,
        charset: 'utf8mb4_0900_ai_ci',
        extra: {
          charset: 'utf8mb4_0900_ai_ci',
        },
      });

      return dataSource.initialize();
    },
  },
];
