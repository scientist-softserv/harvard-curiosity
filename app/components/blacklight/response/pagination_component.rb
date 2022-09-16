# frozen_string_literal: true

module Blacklight
  module Response
    # Render a pagination widget for search results
    class PaginationComponent < ::ViewComponent::Base
      # @param [Blacklight::Response] response
      # @param [Hash] html html options for the pagination container
      def initialize(response:, html: {}, compact: false, **pagination_args)
        @response = response
        @html_attr = { aria: { label: t('views.pagination.aria.container_label') } }.merge(html)
        @pagination_args = pagination_args
        @compact = compact
      end

      def pagination
        if @compact
          local_page_entries_info(@response)
        else
          helpers.paginate @response, **Blacklight::Engine.config.blacklight.default_pagination_options, **@pagination_args
        end
      end

      def local_page_entries_info(collection, entry_name: nil)
        entry_name = if entry_name
                       entry_name.pluralize(collection.size, I18n.locale)
                     else
                       collection.entry_name(count: collection.size).downcase
                     end

        if collection.total_pages < 2
          t('helpers.page_entries_info.one_page.top_display_entries', entry_name: entry_name, count: collection.total_count)
        else
          from = collection.offset_value + 1
          to   = collection.offset_value + (collection.respond_to?(:documents) ? collection.documents : collection.to_a).size

          t('helpers.page_entries_info.more_pages.top_display_entries', entry_name: entry_name, first: from, last: to, total: collection.total_count)
        end.html_safe
      end
    end
  end
end
