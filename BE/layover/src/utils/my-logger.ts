import { Logger } from '@nestjs/common';
import { createLogger, format, transports } from 'winston';

export class MyLogger extends Logger {
  private winstonLogger = createLogger({
    format: format.combine(
      format.timestamp(),
      format.printf(({ level, message, timestamp }) => `${timestamp} ${level}: ${message}`),
    ),
    transports: [new transports.File({ filename: 'logs.log' })],
  });

  log(message: string) {
    super.log(message);
    this.winstonLogger.info(message);
  }

  error(message: string) {
    super.error(message);
    this.winstonLogger.error(message);
  }
}
