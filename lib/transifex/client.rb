module Transifex
  class Client
    include Transifex::Request

    def initialize(options = {})
      set_credentials(
        options[:username] || Transifex.username,
        options[:password] || Transifex.password
      )
    end

    def project(project_slug)
      Projects::ProjectProxy.new(self, project_slug)
    end

    def projects
      Projects::ProjectsProxy.new(self)
    end
  end
end
