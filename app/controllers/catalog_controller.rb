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

    config.add_sort_field 'relevance', sort: 'score desc, id asc', label: I18n.t('spotlight.search.fields.sort.relevance')

    config.add_field_configuration_to_solr_request!

    # enable facets:
    # https://github.com/projectblacklight/spotlight/issues/1812#issuecomment-327345318
    config.add_facet_fields_to_solr_request!

    config.add_facet_field 'creators-contributors_ssim', label: I18n.t(:'spotlight.search.fields.creators-contributors_ssim'), limit: true
    config.add_facet_field 'place-of-origin_ssim', label: I18n.t(:'spotlight.search.fields.place-of-origin_ssim'), limit: true
    config.add_facet_field 'publisher_ssim', label: I18n.t(:'spotlight.search.fields.publisher_ssim'), limit: true
    config.add_facet_field 'creation-date_ssim', label: I18n.t(:'spotlight.search.fields.creation-date_ssim'), limit: true
    config.add_facet_field 'language_ssim', label: I18n.t(:'spotlight.search.fields.language_ssim'), limit: true
    config.add_facet_field 'genre_ssim', label: I18n.t(:'spotlight.search.fields.genre_ssim'), limit: true
    config.add_facet_field 'subjects_ssim', label: I18n.t(:'spotlight.search.fields.subjects_ssim'), limit: true
    config.add_facet_field 'places_ssim', label: I18n.t(:'spotlight.search.fields.places_ssim'), limit: true
    config.add_facet_field 'series_ssim', label: I18n.t(:'spotlight.search.fields.series_ssim'), limit: true
    config.add_facet_field 'digital-format_ssim', label: I18n.t(:'spotlight.search.fields.digital-format_ssim'), limit: true
    config.add_facet_field 'repository_ssim', label: I18n.t(:'spotlight.search.fields.repository_ssim'), limit: true

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

  # rubocop:disable Layout/LineLength, Metrics/MethodLength, Metrics/AbcSize
  def index
    if params[:fulltext]
      ft_solr = RSolr.connect url: 'https://fts.lib.harvard.edu/solr/fts-collection'
      ft_response = ft_solr.get 'select', params: fts_solr_params

      ft_document_list_raw = ft_response['grouped']['objectId']['groups']
      @ft_document_list = {}
      ft_document_list_raw ||= []
      ft_document_list_raw.each do |g|
        context = g['doclist']['docs'].first['content'][/.{0,100}#{params[:q]}.{0,100}/im]
        urn = g['doclist']['docs'].first['urn'].upcase
        @ft_document_list[urn] = g['doclist'].merge(context: context,
                                                    fts_link: fts_search_link(g['groupValue'])).stringify_keys
      end
      # use [:numFound] for 1 of XX results in this book
      # use [:context] for snippet of result

      facet_fields = blacklight_config.facet_fields.values.map(&:field)[0..-2] + ['exhibit_test-exhibit_public_bsi']
      raw_response = ::Blacklight.default_index.connection.get('select',
                                                               params: { q: params[:q],
                                                                         facet: true,
                                                                         'facet.field': facet_fields,
                                                                         rows: fts_solr_params[:rows],
                                                                         start: fts_solr_params[:start] })
      sidecars = Spotlight::SolrDocumentSidecar.where(urn: @ft_document_list.keys, exhibit_id: current_exhibit.id)
      docs = sidecars.map do |sidecar|
        sidecar.to_solr.stringify_keys if sidecar.present?
      end
      raw_response['response']['docs'] = docs
      @response = ::Blacklight::Solr::Response.new(raw_response, raw_response['responseHeader'], blacklight_config: blacklight_config)
      @document_list = ActiveSupport::Deprecation::DeprecatedObjectProxy.new(@response.docs,
                                                                             'The @document_list instance variable is deprecated; use @response.documents instead.')
    else
      (@response, deprecated_document_list) = search_service.search_results
      @document_list = ActiveSupport::Deprecation::DeprecatedObjectProxy.new(deprecated_document_list,
                                                                             'The @document_list instance variable is deprecated; use @response.documents instead.')
    end
    respond_to do |format|
      format.html { store_preferred_view }
      format.rss  { render layout: false }
      format.atom { render layout: false }
      format.json do
        @presenter = Blacklight::JsonPresenter.new(@response,
                                                   blacklight_config)
      end
      additional_response_formats(format)
      document_export_formats(format)
    end
  end
  # rubocop:enable Layout/LineLength, Metrics/MethodLength

  private

  def fts_solr_params
    fts_params = {}
    fts_params[:q] = params[:q] || '*'
    fts_params[:fq] = "setNames:#{current_exhibit.set_name.presence || '*'}"
    fts_params[:group] = true
    fts_params[:'group.field'] = 'objectId'
    fts_params[:'group.ngroups'] = true
    # fts_params[:hl] = true
    fts_params[:wt] = 'ruby'
    fts_params[:rows] = params[:per_page].presence || blacklight_config.default_per_page
    fts_params[:start] = (((params[:page].presence || 1).to_i - 1) * fts_params[:rows].to_i) + 1
    fts_params
  end
  # rubocop:enable Metrics/AbcSize

  def fts_search_link(object_id)
    fts_link = 'https://fts.lib.harvard.edu/fts/search?'
    fts_link += "query=#{params[:q] || '*'}"
    # including the set causes fts to ignore the ID
    # fts_link += "&S=#{current_exhibit.set_name.presence || '*'}"
    fts_link += "&G=#{object_id}"
    fts_link
  end
end
