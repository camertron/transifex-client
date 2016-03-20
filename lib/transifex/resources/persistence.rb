require 'stringio'

module Transifex
  module Resources
    class Persistence
      module ClassMethods
        def create(client, attributes)
          Resources::Persistence.new(client, attributes).create
        end

        def create_or_update(client, attributes)
          Resources::Persistence.new(client, attributes).create_or_update
        end
      end

      extend ClassMethods

      attr_reader :project_slug, :client, :attributes

      def initialize(client, attributes)
        @project_slug = attributes.delete(:project_slug)
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
        payload = attributes.merge(
          content: content_io,
          categories: Categories.load(
            attributes.fetch(:categories, {})
          ).to_s
        )

        url = "project/#{project_slug}/resources/"
        client.post(url, payload)
        Resource.new(project_slug, payload)
      end

      private

      def update_content
        payload = { content: content_io }
        url = "project/#{project_slug}/resource/#{slug}/content/"
        client.put(url, payload)
      end

      def update_details
        categories = Categories.load(
          attributes.fetch(:categories, {})
        )

        payload = attributes.dup
        payload[:categories] = categories.to_a unless categories.empty?

        url = "project/#{project_slug}/resource/#{slug}/"
        client.put(url, payload)
      end

      def slug
        attributes.fetch(:slug)
      end

      def content
        attributes.fetch(:content, nil)
      end

      def has_content?
        !!content
      end

      def resource
        client.project(project_slug).resource(slug)
      end

      def content_io
        io = StringIO::new(content)
        io.set_encoding(Encoding::UTF_8.name)

        Faraday::UploadIO.new(
          io, 'application/octet-stream'
        )
      end
    end
  end
end
