##
# Team model
#
class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission

  scope :my_teams, -> user_id { where(user_id: user_id) }
  scope :belong_to, -> user_id { where(user_team_id: user_id) }
  scope :member?, -> user_id, user_team_id {where(user_id: user_id).where(user_team_id: user_team_id).exists? }

  def self.add_member(user, email_s)
    user_member = User.find_member(user.id, email_s)
    return if user_member.nil?

    # if exist throw exception
    return if Team.where(user_id: user.id).where(user_team_id: user_member.id).exists?

    team = Team.new(user_id: user.id, user_team_id: user_member.id)
    if team.save
      Notifier.send_new_team_email(user, user_member, email_s).deliver_later

    end
  end

  def self.remove(user, user_team_id)
    team = Team.where(user_id: user.id)
               .where(user_team_id: user_team_id).take || not_found
    team.destroy
  end

  ##
  # If that user has permission to execute the action
  #
  def self.permission?(current_user, owner_user, permission)
    begin
      permission_id = Permission.find_by! permission: permission
      Team.find_by! user_id: owner_user, user_team_id: current_user, permission_id: permission_id
    rescue
      return false
    end

    true
  end
end
