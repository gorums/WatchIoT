##
# Team model
#
class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission

  scope :count_by_user, -> user_id { where('user_id = ?', user_id).count }
  scope :belong_to, -> user_team_id { where('user_team_id = ?', user_team_id) }
  scope :my_teams, -> user_team_id { where('user_team_id = ?', user_team_id) }
  scope :find_member, -> user_id, user_team_id { where('user_id = ?', user_id)
                                                .where('user_team_id = ?', user_team_id) }

  ##
  # added a member for the team
  #
  def self.add_member(user, email_s)
    raise StandardError, 'You can not added more members to the team,'\
              ' please contact with us!' unless can_add_member?(user)

    user_member = find_or_create_member(email_s)
    raise StandardError, 'The member can not be added' if user_member.nil?
    raise StandardError, 'The member can not be yourself' if user.id == user_member.id
    raise StandardError, 'The member was adding before' if Team.find_member(user.id, user_member.id).exists?

    Team.create!(user_id: user.id, user_team_id: user_member.id)
    Notifier.send_new_team_email(email_s, user, user_member).deliver_later
  end

  ##
  # remove a member for the team
  #
  def self.remove_member(user, user_team_id)
    raise StandardError, 'The member is not valid' if
        user.nil? || user_team_id.nil?
    member = Team.find_member(user.id, user_team_id).take
    raise StandardError, 'The member is not valid' if member.nil?
    member.destroy!
  end

  private

  ##
  # Find or create a new member to add the team
  #
  def self.find_or_create_member(email_member)
    return if email_member.nil?
    emails = Email.where(email: email_member).all
    # if dont exist create a new account
    return User.create_new_account(email_member) if emails.nil? || emails.empty?
    # if we find only one account
    return emails.first.user if emails.length == 1
    # if we find more of one account, return the principal
    email = Email.find_principal_by_email(email_member).take
    return email.user unless email.nil?
  end

  ##
  # If i can added more members, free account such has 3 members permitted
  #
  def self.can_add_member?(user)
    return false if user.nil?
    members_count = Team.count_by_user user.id
    value = Plan.find_plan_value user.plan_id, 'Team members'
    members_count < value.to_i
  end
end
