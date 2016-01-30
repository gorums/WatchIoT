##
# Project model
#
class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :space

  validates :name, exclusion: { in: %w(create setting projects),
                                message: '%{value} is reserved.' }

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
