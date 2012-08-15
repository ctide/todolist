class AccessDeniedError < StandardError; end

class ApplicationController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  rescue_from AccessDeniedError,
              :with => :handle_access_denied unless Rails.env.development?
  protect_from_forgery
  prepend_before_filter :get_api_key

  def handle_access_denied(exception)
    log_message = "WARNING: #{exception.class} (#{exception.message}) raised by "
    log_message << (current_user ? "user #{current_user.email}" : "an unauthenticated user")
    logger.warn(log_message)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render :json => { :success => false, :error => "Action prohibited." }, :status => 403 }
    end
  end

  def get_api_key
    if api_key = params[:authentication_token].blank? && request.headers["X-AUTHENTICATION-TOKEN"]
      params[:authentication_token] = api_key
    end
  end

end
