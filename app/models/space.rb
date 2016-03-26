# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  is_public     :boolean          default(TRUE)
#  can_subscribe :boolean          default(TRUE)
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

##
# Space model
#
class Space < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  validates_uniqueness_of :name, scope: [:user_id], message: 'You have a space with this name'
  validates :name, presence: true, length: { maximum: 25 }
  validates :name, exclusion: { in: %w(create setting spaces chart),
                                message: '%{value} is reserved.' }

  before_validation :name_format

  scope :count_by_user, -> user_id { where('user_id = ?', user_id).count }

  scope :find_by_user_order, -> user_id { where('user_id = ?', user_id).
        order(created_at: :desc) }

  scope :find_by_user_and_name, -> user_id, namespace {
        where('user_id = ?', user_id).where('name = ?', namespace.downcase) if namespace.present? }

  ##
  # add a new space
  #
  def self.create_new_space(space_params, user, user_owner)
    raise StandardError, 'You can not add more spaces,'\
              ' please contact with us!' unless can_create_space?(user)

    Space.create!(
        name: space_params[:name],
        description: space_params[:description],
        user_id: user.id,
        user_owner_id: user_owner.id)
  end

  ##
  # edit a space, only can edit the description for now
  #
  def self.edit_space(space, description)
    space.update!(description: description)
  end

  ##
  # edit a space, only can edit the namespace for now
  #
  def self.change_space(space, namespace)
    space.update!(name: namespace)
  end

  ##
  # delete a space
  #
  def self.delete_space(space, namespace)
    raise StandardError, 'The namespace is not valid' if
        space.nil? || namespace.nil?
    raise StandardError, 'The namespace is not valid' if
        namespace.downcase != space.name

    raise StandardError, 'This space can not be delete because it has'\
                         ' one or more projects associate' if
        Project.exists?(space_id: space.id)
    space.destroy!
  end

  ##
  # Transfer space and projects to a member team
  #
  def self.transfer(space, user, user_member_id)
    raise StandardError, 'The member is not valid' if
        space.nil? || user.nil? || user_member_id.nil?

    raise StandardError, 'The member is not valid' unless
        Team.find_member(user.id, user_member_id).exists?

    user = User.find(user_member_id)
    raise StandardError, 'The team member can not add more spaces,'\
              ' please contact with us!' unless can_create_space?(user)

    transfer_projects space, user_member_id

    member_email = Email.find_primary_by_user(user_member_id).take
    Notifier.send_transfer_space_email(member_email, user, space)
        .deliver_later unless member_email.nil?
  end

  private

  ##
  # Transfer all the projects belong space
  #
  def self.transfer_projects(space, user_member_id)
    space.update!(user_id: user_member_id)
    Project.where('space_id = ?', space.id).find_each do |p|
      p.update!(user_id: user_member_id)
    end
  end

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters, - and _
  #
  def name_format
    name.gsub!(/[^0-9a-z\-_ ]/i, '_') unless name.nil?
    name.gsub!(/\s+/, '-') unless name.nil?
    self.name = self.name.downcase unless self.name.nil?
  end

  ##
  # If i can added more space, free account such has 3 spaces permitted
  #
  def self.can_create_space?(user)
    return false if user.nil?
    spaces_count = Space.count_by_user user.id
    value = Plan.find_plan_value user.plan_id, 'Number of spaces'
    spaces_count < value.to_i
  end
end
