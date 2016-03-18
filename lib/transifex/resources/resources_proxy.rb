module Transifex
  module Resources
    class ResourcesProxy < Transifex::Proxy
      include Enumerable

      attr_reader :project_slug

      def each(&block)
        fetch.each(&block)
      end

      def fetch
        @resources_list ||=
          client.get("/project/#{project_slug}/resources").map do |resource|
            Resource.new(project_slug, resource)
          end
      end

      def create(attributes)
        Resources::Persistence.new(client, attributes).create
      end

      def create_or_update(attributes)
        Resources::Persistence.new(client, attributes).create_or_update
      end

      private

      def after_initialize(project_slug)
        @project_slug = project_slug
      end

      def reset
        @resource_list = nil
      end
    end
  end
end
