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

      def exists?
        fetch
        true
      rescue Transifex::HttpError
        false
      end

      def resources
        Resources::ResourcesProxy.new(client, project_slug)
      end

      def resource(resource_slug)
        Resources::ResourceProxy.new(client, project_slug, resource_slug)
      end

      def update(attributes)
        persistence = Projects::Persistence.new(
          client, attributes.merge(
            slug: project_slug
          )
        )

        persistence.update
      end

      def delete
        client.delete(url)
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
