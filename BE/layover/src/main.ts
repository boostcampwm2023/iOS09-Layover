import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { GlobalExceptionFilter } from './custom-exception';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalFilters(new GlobalExceptionFilter());
  await app.listen(3000);
}
bootstrap();
