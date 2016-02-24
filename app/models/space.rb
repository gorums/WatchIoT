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

  before_save :name_format

  scope :has_spaces_by_user?, -> user_id { where('user_id = ?', user_id).exists? }

  scope :count_spaces_by_user, -> user_id { where('user_id = ?', user_id).count }

  scope :find_by_user_order, -> user_id { where('user_id = ?', user_id).
        order(created_at: :desc) }

  scope :find_by_user_and_name, -> user_id, namespace {
        where('user_id = ?', user_id).where('name = ?', namespace) if namespace.present? }

  ##
  # add a new space
  #
  def self.create_new_space(space_params, user, user_owner)
    raise StandardError, 'You can not added more spaces,'\
              ' please contact with us!' unless can_create_space?(user)

    Space.create!(
        name: space_params[:name], description: space_params[:description],
        user_id: user.id, user_owner_id: user_owner.id)
  end

  ##
  # edit a space, only can edit the description for now
  #
  def self.edit_space(description, space)
    space.update!(description: description)
  end

  ##
  # edit a space, only can edit the namespace for now
  #
  def self.change_space(namespace, space)
    space.update!(name: namespace)
  end

  ##
  # delete a space
  #
  def self.delete_space(space, namespace)
    raise StandardError, 'The space name is not valid' if space.name != namespace
    raise StandardError, 'You have to transfer or your projects'\
                         ' or delete their' if Project.has_projects? space.id
    space.destroy!
  end

  ##
  # Transfer space and projects to a member team
  #
  def self.transfer(space, user, user_member_id)
    raise StandardError,
          'The member is not valid' unless Team.member? user.id, user_member_id

    space.update!(user_id: user_member_id)
    Project.find_each('space_id = ?', space.id) do |p|
      p.update!(user_id: user_member_id)
    end

    member_email = Email.my_principal user_member_id
    Notifier.send_transfer_space_email(user, space, member_email)
        .deliver_later unless member_email.nil?
  end

  private

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters, - and _
  #
  def name_format
    name.gsub! /[^0-9a-z\-_ ]/i, ''
    name.gsub! /\s+/, '_'
  end

  ##
  # If i can added more space, free account such has 3 spaces permitted
  #
  def self.can_create_space?(user)
    spaces_count = Space.count_spaces_by_user user.id
    value = Plan.find_plan_value user.plan_id, 'Number of spaces'
    spaces_count < value.to_i
  end
end
