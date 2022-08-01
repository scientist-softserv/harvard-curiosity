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
# Spotlight::Engine.config.full_image_field = :full_image_url_ssm
# Spotlight::Engine.config.thumbnail_field = :thumbnail_url_ssm

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
    field_name: :contributor_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.contributor_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :subjects_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.subjects_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :language_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.language_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'citation-title_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.citation-title_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :creator_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.creator_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'start-date_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.start-date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'end-date_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.end-date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :date_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.date_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :format_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.format_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :repository_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.repository_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :type_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.type_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :origin_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.origin_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :biography_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.biography_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'statement-of-responsibility_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.statement-of-responsibility_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :citation_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.citation_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'physical-form_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.physical-form_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :'language-info_tesim',
    label: -> { I18n.t(:'spotlight.search.fields.language-info_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :publications_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.publications_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :funding_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.funding_tesim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :funding_ssim,
    label: -> { I18n.t(:'spotlight.search.fields.funding_ssim') }
  ),
  Spotlight::UploadFieldConfig.new(
    field_name: :rights_tesim,
    label: -> { I18n.t(:'spotlight.search.fields.rights_tesim') }
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
