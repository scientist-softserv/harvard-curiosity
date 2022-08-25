# OVERRIDE FILE from Spotlight v3.3.0

module Spotlight
  # OVERRIDE: change Exhibit Tags label in facets
  module BlacklightConfigurationDecorator
    def add_exhibit_tags_fields(config)
      # rubocop:disable Style/GuardClause
      unless config.show_fields.include? :exhibit_tags
        config.add_show_field :exhibit_tags, field: config.document_model.solr_field_for_tagger(exhibit),
                                             link_to_facet: true,
                                             separator_options: { words_connector: nil, two_words_connector: nil, last_word_connector: nil }
      end

      unless config.facet_fields.include? :exhibit_tags
        # OVERRIDE: add :label key to make use of dynamic I18n
        config.add_facet_field :exhibit_tags, field: config.document_model.solr_field_for_tagger(exhibit), limit: true,
                                              label: I18n.t('spotlight.search.fields.facet.exhibit_tags')
      end
      # rubocop:enable Style/GuardClause
    end
  end
end

Spotlight::BlacklightConfiguration.prepend(Spotlight::BlacklightConfigurationDecorator)
