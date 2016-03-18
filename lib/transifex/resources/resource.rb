module Transifex
  module Resources
    class Resource
      FIELDS = [:categories, :i18n_type, :source_language_code, :slug, :name]
      attr_accessor *FIELDS

      alias_method :resource_slug, :slug

      extend Resources::Persistence::ClassMethods

      def initialize(project_slug, transifex_data)
        @project_slug = project_slug
        @name = transifex_data[:name]
        @categories = transifex_data[:categories]
        @i18n_type = transifex_data[:i18n_type]
        @source_language_code = transifex_data[:source_language_code]
        @slug = transifex_data[:slug]
      end

      def attributes
        {
          name: name,
          categories: categories,
          i18n_type: i18n_type,
          source_language_code: source_language_code,
          slug: slug
        }
      end
    end
  end
end
