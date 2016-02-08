##
# Dashboard controller
#
class DashboardController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username
  #
  def show
    user = find_owner

    @space = Space.new
    @logs = Log.where(user_id: user.id).limit(20)
                .order(created_at: :desc)
  end

end
