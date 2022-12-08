module ApplicationHelper
  include SpotlightHelper

  def retrieve_delivery_service(url)
    response = Net::HTTP.get_response(URI.parse(url))
    response_arr = response.body.split('/')
    response_arr[-1].split(':') if response_arr.length > 1
  end

  def retrieve_still_image_json_metadata(url)
    response = Net::HTTP.get_response(URI.parse(url))
    JSON.parse response.body if response.is_a? Net::HTTPOK
  end

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

  def full_text_search?
    @full_text_search ||= params['fulltext'].present?
  end
end
