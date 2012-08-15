class IndexController < ApplicationController

  def index
    return render 'dashboard' if current_user
  end

end
