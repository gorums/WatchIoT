# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  configuration :text
#  has_errors    :boolean          default(FALSE)
#  status        :boolean          default(TRUE)
#  user_id       :integer
#  space_id      :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

##
# Project model
#
class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :space

  validates_presence_of :name, on: :create
  validates_uniqueness_of :name, scope: [:space_id, :user_id]

  validates :name, presence: true, length: { maximum: 25 }
  validates :name, exclusion: { in: %w(create setting projects),
                                message: '%{value} is reserved.' }

  before_save :name_format

  scope :count_by_user_and_space, -> user_id, space_id {
        where('user_id = ?', user_id).
        where('space_id = ?', space_id).count }

  scope :find_by_user_space_and_name, -> user_id, space_id, project {
        where('user_id = ?', user_id).
        where('space_id = ?', space_id).
        where('name = ?', project.downcase) if project.present? }

  ## -------------------- Instance method ----------------------- ##

  ##
  # edit a project, only can edit the description for now
  #
  def edit_project(description, status)
    update!(description: description, status: status)
  end

  ##
  # edit a project, only can edit the name for now
  #
  def change_project(name)
    update!(name: name)
  end

  ##
  # delete a project
  #
  def delete_project(name)
    raise StandardError, 'The project name is not valid' if name.nil?
    raise StandardError, 'The project name  is not valid' if
        name.downcase != self.name

    destroy!
  end

  ##
  # save the configuration and if it has errors
  #
  def save_project_config(config, has_errors)
    update!(configuration: config, has_errors: has_errors)
  end

  ## ------------------------ Class method ------------------------ ##

  ##
  # add a new space
  #
  def self.create_new_project(space_params, user, space, user_owner)
    raise StandardError, 'You can not add more projects,'\
              ' please contact with us!' unless can_create_project?(user, space)

    Project.create!(
        name: space_params[:name],
        description: space_params[:description],
        user_id: user.id,
        space_id: space.id,
        user_owner_id: user_owner.id)
  end

  ##
  # this method evaluate yaml configuration code syntactic
  # and return an array of errors if there are
  #
  def self.evaluate(config)
    Wiot::Evaluator.parse config, nil
  end

  private

  ## -------------------- Private Instance method ----------------------- ##

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters
  #
  def name_format
    self.name.gsub!(/[^0-9a-z\-_ ]/i, '_') unless self.name.nil?
    self.name.gsub!(/\s+/, '-') unless self.name.nil?
    self.name = self.name.downcase unless self.name.nil?
  end

  ## -------------------- Private Class method ----------------------- ##

  ##
  # If i can added more projects, free account such has 5 projects per space permitted
  #
  def self.can_create_project?(user, space)
    return false if user.nil? || space.nil?
    projects_count = Project.count_by_user_and_space user.id, space.id
    value = user.plan.find_plan_value('Number of projects by space')
    projects_count < value.to_i
  end
end
