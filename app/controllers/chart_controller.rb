##
# Chart controller
#
class ChartController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/chart
  #
  def show
    user = find_owner
    return if user.nil?
  end

end
