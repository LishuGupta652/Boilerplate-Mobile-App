import { ProjectsService } from './projects.service';

describe('ProjectsService', () => {
  it('creates a new project', () => {
    const service = new ProjectsService();
    const project = service.create('New Project');

    expect(project.name).toBe('New Project');
    expect(project.id).toBeDefined();
  });
});
