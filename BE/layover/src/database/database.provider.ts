import { DataSource } from 'typeorm';

export const databaseProviders = [
  {
    provide: 'DATA_SOURCE', // 둘 이상의 provider가 있으면 얘로 구분됨. 따로 작성하지 않으면 class 이름이 provider 키가 됨.
    useFactory: async () => {
      const dataSource = new DataSource({
        type: 'mysql',
        host: '192.168.64.2',
        port: 3306,
        username: 'jh',
        password: '4525',
        database: 'layover_member',
        entities: [__dirname + '/../**/*.entity{.ts,.js}'],
        synchronize: true,
      });

      return dataSource.initialize();
    },
  },
];
