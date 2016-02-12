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

  scope :my_spaces, -> user_id {where(user_id: user_id).order(created_at: :desc)}
  scope :my_space, -> user_id, namespace {where(user_id: user_id).
      where('name = ?', namespace).first if namespace.present?}

  before_save :name_format

  def self.add_space(space_params, user_id, user_owner_id)
    @space = Space.new(space_params)
    @space.user_id =user_id
    @space.user_owner_id = user_owner_id

    @space.save!
  end

  def self.edit_space(space, space_params)
    space.update(space_params)
  end

  def self.delete_space(space, space_params)
    not_found if space.name != space_params[:name]
    # throw exception
    not_found if Project.where(space_id: space.id).any?

    space.destroy!
  end

  ##
  # Transfer space and projects to this team member
  #
  def self.transfer(space, user, user_member_id)
    # TODO: if he is not my team member, throw exception
    my_team = Team.where(user_id: user.id).where(user_team_id: user_member_id).any?
    not_found unless my_team

    space.update(user_id: user_member_id)
    Project.where(space_id: space.id).each do |p|
      p.update_attribute(:user_id, user_member_id)
    end

    member_email = user_email(user_member_id)
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
end
