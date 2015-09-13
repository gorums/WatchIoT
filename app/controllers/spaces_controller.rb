class SpacesController < ApplicationController
  layout 'dashboard'

  def index
    redirect_to :root if !is_auth?
  end
end
