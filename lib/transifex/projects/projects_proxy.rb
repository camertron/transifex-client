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

      private

      def reset
        @project_list = nil
      end
    end
  end
end
