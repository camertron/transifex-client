require 'delegate_it'

module Transifex
  module Resources
    class ResourceProxy < Transifex::Proxy
      extend DelegateIt

      delegate *Resource::FIELDS, to: :fetch

      attr_reader :project_slug, :resource_slug

      def fetch
        @resource ||= Resource.new(
          project_slug, client.get(
            "/project/#{project_slug}/resource/#{resource_slug}"
          )
        )
      end

      def exists?
        fetch
        true
      rescue Transifex::Error
        false
      end

      def update(attributes)
        Resources::Persistence.new(client, attributes).update
      end

      private

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
