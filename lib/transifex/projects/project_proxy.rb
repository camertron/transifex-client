require 'delegate_it'

module Transifex
  module Projects
    class ProjectProxy < Transifex::Proxy
      extend DelegateIt

      delegate *Project::FIELDS, to: :fetch

      attr_reader :project_slug

      def fetch
        @project ||= Project.new(
          client.get(url)
        )
      end

      def resources
        Resources::ResourcesProxy.new(client, project_slug)
      end

      def resource(resource_slug)
        Resources::ResourceProxy.new(client, project_slug, resource_slug)
      end

      private

      def url
        @url ||= "project/#{project_slug}/"
      end

      def reset
        @project = nil
      end

      def after_initialize(project_slug)
        @project_slug = project_slug
      end
    end
  end
end
