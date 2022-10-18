module Curiosity
  module Rendering
    # Replaces Blacklight::Rendering::Join in Blacklight's rendering pipeline,
    # effectively overriding it.
    #
    # By default, Blacklight renders multiple values in a human-readable way;
    # specifically, by joining the values using commas and "and"s.
    # Example: "First Title, Second Title and Third Title"
    # @see Blacklight::Rendering::Join#render
    #
    # Instead, we break multiple values into their own lines using HTML breaks.
    # Also, we hyperlink values that start with "https".
    class BlacklightJoinOverride < Blacklight::Rendering::Join
      def render
        next_step(values.map { |v| sanitize_and_linkify(v) }.join('<br />').html_safe)
      end

      private

        def sanitize_and_linkify(value)
          sanitized_value = html_escape(value)
          return sanitized_value unless sanitized_value.start_with?('http')

          "<a href='#{sanitized_value}'>#{sanitized_value}</a>"
        end
    end
  end
end
