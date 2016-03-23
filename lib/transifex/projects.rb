module Transifex
  module Projects
    autoload :Persistence,   'transifex/projects/persistence'
    autoload :Project,       'transifex/projects/project'
    autoload :ProjectProxy,  'transifex/projects/project_proxy'
    autoload :ProjectsProxy, 'transifex/projects/projects_proxy'
  end
end
