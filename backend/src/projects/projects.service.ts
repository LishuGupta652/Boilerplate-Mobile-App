import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';

export interface Project {
  id: string;
  name: string;
  status: string;
  updatedAt: string;
}

@Injectable()
export class ProjectsService {
  private projects: Project[] = [
    {
      id: randomUUID(),
      name: 'Mobile Launch',
      status: 'active',
      updatedAt: new Date().toISOString(),
    },
    {
      id: randomUUID(),
      name: 'Backend Sprint',
      status: 'planning',
      updatedAt: new Date().toISOString(),
    },
  ];

  findAll() {
    return this.projects;
  }

  create(name: string) {
    const project: Project = {
      id: randomUUID(),
      name,
      status: 'active',
      updatedAt: new Date().toISOString(),
    };

    this.projects = [project, ...this.projects];
    return project;
  }
}
