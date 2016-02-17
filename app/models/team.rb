##
# Team model
#
class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission

  scope :my_teams, -> user_id { where('user_id = ?', user_id) }
  scope :belong_to, -> user_team_id { where('user_team_id = ?', user_team_id) }
  scope :member?, -> user_id, user_team_id { where('user_id = ?', user_id)
                                                 .where('user_team_id = ?', user_team_id).exists? }

  scope :member, -> user_id, user_team_id { where('user_id = ?', user_id)
                                                .where('user_team_id = ?', user_team_id).take }

  ##
  # added a member for the team
  #
  def self.add_member(user, email_s)
    can_add_member(user)
    user_member = User.find_member(user.id, email_s)
    raise StandardError, 'The member can not be added' if user_member.nil?
    raise StandardError, 'The member can not be yourself' if user.id == user_member.id
    raise StandardError, 'The member was adding before' if Team.member? user.id, user_member.id

    team = Team.new(user_id: user.id, user_team_id: user_member.id)
    team.save!
    Notifier.send_new_team_email(user, user_member, email_s).deliver_later
  end

  ##
  # remove a member for the team
  #
  def self.remove(user, user_team_id)
    member = Team.member user.id, user_team_id
    raise StandardError, 'The member is not valid' if member.nil?
    member.destroy!
  end

  private

  ##
  # If i can added more members, free account such has 3 members permitted
  #
  def can_add_member(user)
    members_count = Team.my_teams(user.id).count
    value = Plan.plan_value user.plan_id, 'Team members'
    if members_count >= value
      raise StandardError, 'You can not added more members, please contact with us!'
    end
  end
end
