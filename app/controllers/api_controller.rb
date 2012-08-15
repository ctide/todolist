class ApiController < ApplicationController
  before_filter :authenticate_user!, :except => :authentication_token

  def todo_list
    render :json => current_user.entries
  end

  def authentication_token
    user = User.find(:first, :conditions => ["email ILIKE ?", params[:email]])
    raise AccessDeniedError if user.nil?
    raise AccessDeniedError if !user.valid_password?(params[:password])
    render :json => {auth_token: user.authentication_token, user: {user_id: user.id}}
  end

end
