class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def create
    e = current_user.entries.create(params[:entry])
    e.save!
    render :json => e
  end

  def update
    e = current_user.entries.find(params[:id])
    e.update_attributes(params[:entry])
    render :json => e
  end

  def todo_list
    render :json => current_user.undone_entries
  end


end
