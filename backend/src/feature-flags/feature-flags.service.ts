import { Injectable } from '@nestjs/common';

@Injectable()
export class FeatureFlagsService {
  private baseFlags = {
    'projects.create': true,
    'teams.invites': true,
    'push.enable': false,
    'offline.sync': true,
  };

  forUser(user?: { roles?: string[] }) {
    if (user?.roles?.includes('admin')) {
      return {
        ...this.baseFlags,
        'admin.console': true,
      };
    }

    return this.baseFlags;
  }
}
