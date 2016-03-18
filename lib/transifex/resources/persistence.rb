require 'stringio'

module Transifex
  module Resources
    class Persistence
      attr_reader :client, :attributes

      module ClassMethods
        def create(client, attributes)
          Resources::Persistence.new(client, attributes).create
        end

        def create_or_update(client, attributes)
          Resources::Persistence.new(client, attributes).create_or_update
        end
      end

      extend ClassMethods

      def initialize(client, attributes)
        @client = client
        @attributes = attributes
      end

      def create_or_update
        if resource.exists?
          update
        else
          create
        end
      end

      def update
        # update details first so new content is always tagged
        update_details
        update_content if has_content?
      end

      def create
        payload = {
          slug: resource_slug,
          name: source_file,
          i18n_type: attributes.fetch(:type),
          categories: CategorySupport.join_categories(categories),
          content: content_io
        }

        url = "#{API_ROOT}/project/#{project_slug}/resources/"
        client.post(url, payload)
        Resource.new(project_slug, payload)
      end

      private

      def update_content
        payload = { content: content_io }
        url = "#{API_ROOT}/project/#{project_slug}/resource/#{resource_slug}/content/"
        client.put(url, payload)
      end

      def update_details
        url = "#{API_ROOT}/project/#{project_slug}/resource/#{resource_slug}/"
        client.put(url, details)
      end

      def project_slug
        attributes.fetch(:project_slug)
      end

      def resource_slug
        attributes.fetch(:resource_slug)
      end

      def content
        attributes.fetch(:content)
      end

      def type
        attributes.fetch(:type)
      end

      def has_content?
        !!content
      end

      def source_file
        attributes.fetch(:source_file)
      end

      def resource
        client.project(project_slug).resource(resource_slug)
      end

      def categories
        @categories ||= begin
          new_categories = attributes.fetch(:categories, [])
          old_categories = Set.new(resource.categories)
          old_categories.merge(new_categories).to_a
        end
      end

      def content_io
        io = StringIO::new(content)
        io.set_encoding(Encoding::UTF_8.name)

        Faraday::UploadIO.new(
          io, 'application/octet-stream', source_file
        )
      end
    end
  end
end
