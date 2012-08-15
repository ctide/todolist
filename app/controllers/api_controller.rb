class ApiController < ApplicationController
  def authentication_token
    user = User.find(:first, :conditions => ["email ILIKE ?", params[:email]])
    raise AccessDeniedError if user.nil?
    raise AccessDeniedError if !user.valid_password?(params[:password])
    render :json => {auth_token: user.authentication_token, user: {user_id: user.id}}
  end

end
