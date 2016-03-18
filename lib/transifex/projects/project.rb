module Transifex
  module Projects
    class Project
      FIELDS = [:name, :description, :source_language_code, :slug]
      attr_accessor *FIELDS

      alias_method :project_slug, :slug

      def initialize(transifex_data)
        @name = transifex_data[:name]
        @description = transifex_data[:description]
        @source_language_code = transifex_data[:source_language_code]
        @slug = transifex_data[:slug]
      end

      def resources
        ResourcesProxy.new(client, project_slug)
      end

      def resource(resource_slug)
        ResourceProxy.new(client, project_slug, resource_slug)
      end
    end
  end
end
