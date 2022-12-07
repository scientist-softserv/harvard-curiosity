class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  layout :determine_layout if respond_to? :layout

  helper_method :search_parameters?

  # Use custom error pages
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Blacklight::Exceptions::RecordNotFound, with: :not_found

  def not_found
    render :status => 404, :layout => false
  end

  # Check if any search parameters have been set
  # @return [Boolean]
  def search_parameters?
    params[:search_field].present? || search_state.has_constraints?
  end
end
