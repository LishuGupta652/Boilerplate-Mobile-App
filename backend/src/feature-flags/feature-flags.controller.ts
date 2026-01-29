import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

import { FeatureFlagsService } from './feature-flags.service';

@Controller('flags')
@UseGuards(AuthGuard('jwt'))
export class FeatureFlagsController {
  constructor(private readonly featureFlagsService: FeatureFlagsService) {}

  @Get()
  getFlags(@Req() req: any) {
    return this.featureFlagsService.forUser(req.user);
  }
}
