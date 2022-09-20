# frozen_string_literal: true

# ==> User model
# Note that your chosen model must include Spotlight::User mixin
# Spotlight::Engine.config.user_class = '::User'

# ==> Blacklight configuration
# Spotlight uses this upstream configuration to populate settings for the curator
# Spotlight::Engine.config.catalog_controller_class = '::CatalogController'
# Spotlight::Engine.config.default_blacklight_config = nil

# ==> Appearance configuration
# Spotlight::Engine.config.exhibit_main_navigation = [:curated_features, :browse, :about]
# Spotlight::Engine.config.resource_partials = [
#   'spotlight/resources/external_resources_form',
#   'spotlight/resources/upload/form',
#   'spotlight/resources/csv_upload/form',
#   'spotlight/resources/json_upload/form'
# ]
# Spotlight::Engine.config.external_resources_partials = []
# Spotlight::Engine.config.default_browse_index_view_type = :gallery
# Spotlight::Engine.config.default_contact_email = nil

# ==> Solr configuration
# Spotlight::Engine.config.writable_index = true
# Spotlight::Engine.config.solr_batch_size = 20
# Spotlight::Engine.config.filter_resources_by_exhibit = true
# Spotlight::Engine.config.autocomplete_search_field = 'autocomplete'
# Spotlight::Engine.config.default_autocomplete_params = { qf: 'id^1000 full_title_tesim^100 id_ng full_title_ng' }

# Solr field configurations
# Spotlight::Engine.config.solr_fields.prefix = ''.freeze
# Spotlight::Engine.config.solr_fields.boolean_suffix = '_bsi'.freeze
# Spotlight::Engine.config.solr_fields.string_suffix = '_ssim'.freeze
# Spotlight::Engine.config.solr_fields.text_suffix = '_tesim'.freeze
# Spotlight::Engine.config.resource_global_id_field = :"#{config.solr_fields.prefix}spotlight_resource_id#{config.solr_fields.string_suffix}"
Spotlight::Engine.config.full_image_field = :full_image_url_ssm
Spotlight::Engine.config.thumbnail_field = :thumbnail_url_ssm

# Creating a namespace to highlight application specific functions.
module Curiosity
  # This method returns a function; the returned function receives a "context"; what is the context?
  # Likely an instance of the CatalogController which will include the current action requested
  # (e.g. `"index"` if we're on the search page, and `"show"` page).
  #
  # @params action_names [Hash<Symbol, Boolean>]
  # @return [Proc]
  #
  # @see https://github.com/projectblacklight/blacklight/wiki/Configuration---Results-View#conditional-rendering
  def self.render_field_for_actions(**action_names)
    @render_for_cache ||= {}
    # Why cache this?  Because we don't want a bunch of dangling one time Procs in the later configuration.
    @render_for_cache[action_names] ||= ->(context, *) { action_names.fetch(context.action_name.to_sym, true) }
  end
end

# ==> Uploaded item configuration
Spotlight::Engine.config.upload_fields = [
  Spotlight::UploadFieldConfig.new(
    field_name: :'additional-digital-items_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.additional-digital-items_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'creator-contributor_tesim',
    blacklight_options: { if: true },
    label: -> { I18n.t(:'spotlight.search.fields.creator-contributor_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'creators-contributors_ssim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.creators-contributors_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :attribution_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.attribution_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :date_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :date_ssim,
    blacklight_options: { if: true },
    label: -> { I18n.t(:'spotlight.search.fields.date_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'place-of-origin_tesim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.place-of-origin_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'place-of-origin_ssim',
    blacklight_options: { if: true },
    label: -> { I18n.t(:'spotlight.search.fields.place-of-origin_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :publisher_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.publisher_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :publisher_ssim,
    blacklight_options: { if: true },
    label: -> { I18n.t(:'spotlight.search.fields.publisher_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :description_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.description_tesim') },
    form_field_type: :text_area
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :edition_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.edition_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :extent_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.extent_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :language_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.language_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :language_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.language_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :genre_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.genre_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :genre_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.genre_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'digital-format_tesim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.digital-format_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'digital-format_ssim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.digital-format_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :contents_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.contents_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :subjects_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.subjects_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :subjects_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.subjects_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :culture_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.culture_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :culture_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.culture_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'style-period_tesim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.style-period_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'style-period_ssim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.style-period_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'materials-techniques_ssim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.materials-techniques_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'materials-techniques_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.materials-techniques_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :places_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.places_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :places_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.places_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :note_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.note_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'cite-as_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.cite-as_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'in-collection_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.in-collection_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :container_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.container_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :series_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.series_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :series_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.series_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :classification_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.classification_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :repository_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.repository_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :repository_tesim,
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.repository_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :rights_tesim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.rights_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'record-id_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.record-id_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'finding-aid-component_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.finding-aid-component_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'hollis-record_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.hollis-record_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'unique-id_tesim',
    # TODO: Should we display this?
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.unique-id_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'search-id_tesim',
    # TODO: Should we display this?
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.search-id_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'finding-aid_tesim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.finding-aid_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :collection_ssim,
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.collection_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'available-to_tesim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.available-to_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'available-to_ssim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.available-to_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ham_ssim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ham_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ham_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ham_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-dcp_ssim',
    blacklight_options: { if: false },
    label: -> { I18n.t(:'spotlight.search.fields.permalink-dcp_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-dcp_tesim',
    blacklight_options: { if: Curiosity.render_field_for_actions(show: true, index: false) },
    label: -> { I18n.t(:'spotlight.search.fields.permalink-dcp_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :thumbnail_url_ssm,
    label: -> { I18n.t(:'spotlight.search.fields.thumbnail_url_ssm') },
    blacklight_options: { if: false }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :full_image_url_ssm,
    label: -> { I18n.t(:'spotlight.search.fields.full_image_url_ssm') },
    blacklight_options: { if: false }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :urn_ssi,
    label: -> { I18n.t(:'spotlight.search.fields.urn_ssi') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :manifest_url_ssm,
    label: -> { I18n.t(:'spotlight.search.fields.manifest_url_ssm') },
    blacklight_options: { if: false }
  )
]
# Spotlight::Engine.config.upload_title_field = nil # UploadFieldConfig.new(...)
# Spotlight::Engine.config.uploader_storage = :file
# Spotlight::Engine.config.allowed_upload_extensions = %w(jpg jpeg png)

Spotlight::Engine.config.featured_image_thumb_size = [800, 600]
# Spotlight::Engine.config.featured_image_square_size = [400, 400]

# ==> Google Analytics integration
# Spotlight::Engine.config.analytics_provider = Spotlight::Analytics::Ga
# Spotlight::Engine.config.ga_pkcs12_key_path = nil
# Spotlight::Engine.config.ga_web_property_id = nil
# Spotlight::Engine.config.ga_email = nil
# Spotlight::Engine.config.ga_analytics_options = {}
# Spotlight::Engine.config.ga_page_analytics_options = config.ga_analytics_options.merge(limit: 5)
# Spotlight::Engine.config.ga_anonymize_ip = false # false for backwards compatibility

# ==> Sir Trevor Widget Configuration
# These are set by default by Spotlight's configuration,
# but you can customize them here, or in the SirTrevorRails::Block#custom_block_types method
# Spotlight::Engine.config.sir_trevor_widgets = %w(
#   Heading Text List Quote Iframe Video Oembed Rule UploadedItems Browse BrowseGroupCategories LinkToSearch
#   FeaturedPages SolrDocuments SolrDocumentsCarousel SolrDocumentsEmbed
#   SolrDocumentsFeatures SolrDocumentsGrid SearchResults
# )
#
# Page configurations made available to widgets
# Spotlight::Engine.config.page_configurations = {
#   'my-local-config': ->(context) { context.my_custom_data_path(context.current_exhibit) }
# }

Spotlight::Engine.config.exhibit_themes = %w[default no_thumbnail_or_viewer vanilla_spotlight]

# changes the dimensions of the exhibit masthead
Spotlight::Engine.config.featured_image_masthead_size = [2000, 350]
Spotlight::Engine.config.masthead_initial_crop_selection = [1600, 280]
