# frozen_string_literal: true

# OVERRIDE show method from Blacklight 7.24.0

##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
    config.show.oembed_field = :oembed_url_ssm
    config.show.partials.insert(1, :oembed)

    config.view.gallery!.document_component = Blacklight::Gallery::DocumentComponent
    config.view.gallery.classes = 'row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-xl-4'
    config.view.masonry!.document_component = Blacklight::Gallery::DocumentComponent
    config.view.masonry!.title_only_by_default = true
    config.view.slideshow!.document_component = Blacklight::Gallery::SlideshowComponent
    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)

    config.index.thumbnail_field = Spotlight::Engine.config.thumbnail_field
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = 'full_title_tesim'

    config.add_search_field 'all_fields', label: I18n.t('spotlight.search.fields.search.all_fields')

    config.add_sort_field 'relevance', sort: 'score desc', label: I18n.t('spotlight.search.fields.sort.relevance')

    config.add_field_configuration_to_solr_request!

    # enable facets:
    # https://github.com/projectblacklight/spotlight/issues/1812#issuecomment-327345318
    config.add_facet_fields_to_solr_request!

    config.add_facet_field 'creators-contributors_ssim', label: I18n.t(:'spotlight.search.fields.creators-contributors_ssim'), limit: true
    config.add_facet_field 'place-of-origin_ssim', label: I18n.t(:'spotilight.search.fields.place-of-origin_ssim'), limit: true
    config.add_facet_field 'publisher_ssim', label: I18n.t(:'spotilight.search.fields.publisher_ssim'), limit: true
    config.add_facet_field 'creation-date_ssim', label: I18n.t(:'spotilight.search.fields.creation-date_ssim'), limit: true
    config.add_facet_field 'language_ssim', label: I18n.t(:'spotilight.search.fields.language_ssim'), limit: true
    config.add_facet_field 'genre_ssim', label: I18n.t(:'spotilight.search.fields.genre_ssim'), limit: true
    config.add_facet_field 'subjects_ssim', label: I18n.t(:'spotilight.search.fields.subjects_ssim'), limit: true
    config.add_facet_field 'places_ssim', label: I18n.t(:'spotilight.search.fields.places_ssim'), limit: true
    config.add_facet_field 'series_ssim', label: I18n.t(:'spotilight.search.fields.series_ssim'), limit: true
    config.add_facet_field 'digital-format_ssim', label: I18n.t(:'spotilight.search.fields.digital-format_ssim'), limit: true
    config.add_facet_field 'repository_ssim', label: I18n.t(:'spotilight.search.fields.repository_ssim'), limit: true

    # Set which views by default only have the title displayed, e.g.,
    # config.view.gallery.title_only_by_default = true

    # Maximum number of results to show per page
    config.max_per_page = 96
    # Options for the user for number of results to show per page
    config.per_page = [5, 12, 24, 48, 96]

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)
  end

  # OVERRIDE from Blacklight 7.24.0: make the show page path accept uppercase and lowercase urns in the browser to be compatible with previous spotlight urls.
  def show
    uppercase_id = params[:id].upcase
    redirect_to({ action: :show, id: uppercase_id }, status: :moved_permanently) if (params[:id] =~ /[a-z]/).present?

    deprecated_response, @document = search_service.fetch(uppercase_id)
    @response = ActiveSupport::Deprecation::DeprecatedObjectProxy.new(deprecated_response,
                                                                      'The @response instance variable is deprecated; use @document.response instead.')
    @manifest_url = @document['manifest_url_ssm']&.first

    respond_to do |format|
      format.html { @search_context = setup_next_and_previous_documents }
      format.json
      additional_export_formats(@document, format)
    end
  end

end
