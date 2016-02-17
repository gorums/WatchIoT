##
# Space model
#
class Space < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  validates_presence_of :name, on: :create
  validates_uniqueness_of :name, scope: [:user_id]

  validates :name, length: { maximum: 15 }

  validates :name, exclusion: { in: %w(create setting spaces chart),
                                message: '%{value} is reserved.' }
  # include ActiveModel::Validations
  # validates_with SpaceCanCreateValidator, on: :create
  # validates_with SpaceCanEditValidator, on: :update

  scope :my_spaces, -> user_id { where('user_id = ?', user_id).order(created_at: :desc) }
  scope :my_space, -> user_id, namespace { where('user_id = ?', user_id)
                                               .where('name = ?', namespace).first if namespace.present? }
  scope :has_spaces?, -> user_id {where('user_id = ?', user_id).exists? }

  before_save :name_format

  ##
  # add a new space
  #
  def self.add_space(space_params, user_id, user_owner_id)
    can_add_space user_id
    space = Space.new(space_params)
    space.user_id = user_id
    space.user_owner_id = user_owner_id

    space.save!
  end

  ##
  # edit a space
  #
  def self.edit_space(space, space_params)
    space.update!(space_params)
  end

  ##
  # delete a space
  #
  def self.delete_space(space, namespace)
    raise StandardError, 'The space name is not valid' if space.name != namespace
    if Project.has_projects? space.id
      raise StandardError, 'You have to transfer or your projects or delete their'
    end

    space.destroy!
  end

  ##
  # Transfer space and projects to a member team
  #
  def self.transfer(space, user, user_member_id)
    raise StandardError, 'The member is not valid' unless Team.member? user.id, user_member_id

    space.update!(user_id: user_member_id)
    Project.find_each('space_id = ?', space.id) do |p|
      p.update!(user_id: user_member_id)
    end

    member_email = Email.my_principal user_member_id
    Notifier.send_transfer_space_email(user, space, member_email).deliver_later unless member_email.nil?
  end

  private

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters
  #
  def name_format
    name.gsub! /[^0-9a-z\- ]/i, '_'
    name.downcase.gsub! /\s+/, '_'
  end

  ##
  # If i can added more space, free account such has 3 spaces permitted
  #
  def self.can_add_space(user_id)
    spaces_count = Space.my_spaces(user_id).count
    value = Plan.plan_value user.plan_id, 'Number of spaces'
    if spaces_count >= value
      raise StandardError, 'You can not added more spaces, please contact with us!'
    end
  end
end
