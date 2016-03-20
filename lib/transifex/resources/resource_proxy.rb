require 'delegate_it'

module Transifex
  module Resources
    class ResourceProxy < Transifex::Proxy
      extend DelegateIt

      delegate *Resource::FIELDS, to: :fetch

      attr_reader :project_slug, :resource_slug

      def fetch
        @resource ||= Resource.new(project_slug, client.get(url))
      end

      def exists?
        fetch
        true
      rescue Transifex::Error
        false
      end

      def update(attributes)
        persistence = Resources::Persistence.new(
          client, attributes.merge(
            project_slug: project_slug,
            slug: resource_slug
          )
        )

        persistence.update
      end

      def delete
        client.delete(url)
      end

      private

      def url
        @url ||= "project/#{project_slug}/resource/#{resource_slug}"
      end

      def reset
        @resource = nil
      end

      def after_initialize(project_slug, resource_slug)
        @project_slug = project_slug
        @resource_slug = resource_slug
      end
    end
  end
end
