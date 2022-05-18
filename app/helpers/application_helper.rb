module ApplicationHelper
  include SpotlightHelper

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    asset = assets&.find_asset(filename)

    if asset
      file = asset.source.force_encoding("UTF-8")
      doc = Nokogiri::HTML::DocumentFragment.parse file
      svg = doc.at_css "svg"
      svg["class"] = options[:class] if options[:class].present?
    else
      doc = "<!-- SVG #{filename} not found -->"
    end

    raw doc
  end

  # add this into the application controller since it was only available in pages controller previously
  # Insert soft breaks into email addresses so they wrap nicely
  def render_contact_email_address(address)
    mail_to address, sanitize(address).gsub(/([@\.])/, '\1<wbr />').html_safe
  end
end
