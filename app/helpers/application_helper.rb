module ApplicationHelper
  include SpotlightHelper

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    asset = assets&.find_asset(filename)

    if asset
      file = asset.source.force_encoding('UTF-8')
      doc = Nokogiri::HTML::DocumentFragment.parse file
      svg = doc.at_css 'svg'
      svg['class'] = options[:class] if options[:class].present?
    else
      doc = "<!-- SVG #{filename} not found -->"
    end

    raw doc
  end

  # add this into the application controller since it was only available in pages controller previously
  # Insert soft breaks into email addresses so they wrap nicely
  def render_contact_email_address(address)
    mail_to address, sanitize(address).gsub(/([@.])/, '\1<wbr />').html_safe
  end

  # @param doc_presenter [Blacklight::ShowPresenter]
  # @param field [Blacklight::Configuration::IndexField]
  #
  # @return [String] the string representation of the values; any values that are URLs are converted to links.
  #
  # @see https://github.com/projectblacklight/blacklight/wiki/Configuration---Results-View#helper-method
  def render_presented_show_field_value(doc_presenter:, field:)
    doc_presenter.field_value(field, except_operations: [Blacklight::Rendering::Join]).map do |value|
      link_to_if value.start_with?('http'), value, value
    end.join('<br />')
  end
end
