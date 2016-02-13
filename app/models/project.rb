##
# Project model
#
class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :space

  validates_presence_of :name, on: :create
  validates_uniqueness_of :name, scope: [:space_id, :user_id]

  validates :name, exclusion: { in: %w(create setting projects),
                                message: '%{value} is reserved.' }

  scope :has_projects?, -> space_id {where('space_id = ?', space_id).exists? }

  before_save :name_format

  private

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters
  #
  def name_format
    name.gsub! /[^0-9a-z ]/i, '_'
    name.downcase.gsub! /\s+/, '_'
  end
end
