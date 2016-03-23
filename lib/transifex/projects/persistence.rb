module Transifex
  module Projects
    class Persistence
      attr_reader :client, :attributes

      module ClassMethods
        def create(client, attributes)
          Projects::Persistence.new(client, attributes).create
        end

        def create_or_update(client, attributes)
          Projects::Persistence.new(client, attributes).create_or_update
        end
      end

      extend ClassMethods

      attr_reader :client, :attributes

      def initialize(client, attributes)
        @client = client
        @attributes = attributes
      end

      def create_or_update
        if project.exists?
          update
        else
          create
        end
      end

      def update
        payload = attributes.dup
        payload.delete(:slug)
        url = "project/#{slug}/"
        client.put(url, payload)
      end

      def create
        url = 'projects/'
        client.post(url, attributes)
        Project.new(attributes)
      end

      def slug
        attributes.fetch(:slug)
      end

      def project
        client.project(slug)
      end
    end
  end
end
