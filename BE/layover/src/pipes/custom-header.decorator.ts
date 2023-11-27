import { ExecutionContext, createParamDecorator } from '@nestjs/common';

export const CustomHeader = createParamDecorator((data: string, ctx: ExecutionContext) => {
  const req = ctx.switchToHttp().getRequest();
  return data ? req.headers[data] : req.headers;
});
