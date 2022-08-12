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

# ==> Uploaded item configuration
Spotlight::Engine.config.upload_fields = [
  Spotlight::UploadFieldConfig.new(
    field_name: :spotlight_upload_description_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_description_tesim') },
    form_field_type: :text_area
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :spotlight_upload_attribution_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_attribution_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :spotlight_upload_date_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'unique-id_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.unique-id_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'search-id_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.search-id_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :series_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.series_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :series_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.series_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'creator-contributor_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.creator-contributor_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'creators-contributors_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.creators-contributors_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :creator_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.creator_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :contributor_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.contributor_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :publisher_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.publisher_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :publisher_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.publisher_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :container_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.container_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'place-of-origin_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.place-of-origin_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'place-of-origin_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.place-of-origin_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :date_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :date_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.date_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :edition_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.edition_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :classification_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.classification_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :spotlight_upload_description_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.spotlight_upload_description_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :contents_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.contents_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :extent_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.extent_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'digital-format_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.digital-format_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'digital-format_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.digital-format_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'harvard-repository_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.harvard-repository_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :language_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.language_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :language_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.language_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :culture_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.culture_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :culture_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.culture_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'style-period_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.style-period_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'style-period_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.style-period_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'materials-techniques_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.materials-techniques_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'materials-techniques_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.materials-techniques_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'finding-aid_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.finding-aid_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'finding-aid-component_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.finding-aid-component_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :repository_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.repository_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :repository_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.repository_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'shelf-location_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.shelf-location_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :subjects_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.subjects_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :subjects_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.subjects_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :genre_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.genre_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :genre_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.genre_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :places_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.places_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :places_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.places_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :attribution_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.attribution_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'in-collection_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.in-collection_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'cite-as_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.cite-as_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :note_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.note_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'additional-digital-items_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.additional-digital-items_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'record-id_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.record-id_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'creation-date_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.creation-date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'creation-date_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.creation-date_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'available-to_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.available-to_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'available-to_ssim',
    label: -> { I18n.t(:'spotlight.search.fields.available-to_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'hollis-record_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.hollis-record_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-dcp_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-dcp_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-botanicals_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-botanicals_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-buttons_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-buttons_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-channing_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-channing_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-citymaps_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-citymaps_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-contagion_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-contagion_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-crb_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-crb_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-crimes_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-crimes_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-currency_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-currency_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-dag_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-dag_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-epj_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-epj_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-exp_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-exp_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-franceinamerica_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-franceinamerica_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ham_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ham_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-hedda_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-hedda_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-horblit_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-horblit_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ihp_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ihp_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-immigration_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-immigration_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-lap_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-lap_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-maps_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-maps_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-medmss_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-medmss_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-reading_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-reading_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-rubbings_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-rubbings_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-saef_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-saef_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-scarlet_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-scarlet_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-scores_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-scores_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ssb_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ssb_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-story_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-story_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ward_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ward_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-wave_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-wave_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'permalink-ww_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.permalink-ww_tesim') }
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
    field_name: :manifest_url_ssm,
    label: -> { I18n.t(:'spotlight.search.fields.manifest_url_ssm') },
    blacklight_options: { if: false }
  )
]
# Spotlight::Engine.config.upload_title_field = nil # UploadFieldConfig.new(...)
# Spotlight::Engine.config.uploader_storage = :file
# Spotlight::Engine.config.allowed_upload_extensions = %w(jpg jpeg png)

# Spotlight::Engine.config.featured_image_thumb_size = [400, 300]
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
