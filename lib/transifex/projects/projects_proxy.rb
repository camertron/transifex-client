module Transifex
  module Projects
    class ProjectsProxy < Transifex::Proxy
      include Enumerable

      def each(&block)
        fetch.each(&block)
      end

      def fetch
        @project_list ||= client.get('/projects/').map do |project|
          Project.new(project)
        end
      end

      def create(attributes)
        Projects::Persistence.new(client, attributes).create
      end

      def create_or_update(attributes)
        Projects::Persistence.new(client, attributes).create_or_update
      end

      private

      def reset
        @project_list = nil
      end
    end
  end
end
