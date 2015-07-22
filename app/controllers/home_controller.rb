class HomeController < ApplicationController
  def index
    @msg = "This my first programing controller"
  end

  def show
    head :bad_request
  end
end
