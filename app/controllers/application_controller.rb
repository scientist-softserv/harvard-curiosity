class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  layout :determine_layout if respond_to? :layout

  helper_method :search_parameters?

  def not_found
    send_file 'public/404.html', disposition: 'inline', type: 'text/html; charset=utf-8', status: 404
  end

  # Check if any search parameters have been set
  # @return [Boolean]
  def search_parameters?
    params[:search_field].present? || search_state.has_constraints?
  end
end
