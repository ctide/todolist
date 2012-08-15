class IndexController < ApplicationController

  def index
    return render 'dashboard' if current_user
    redirect_to new_user_session_path
  end

end
