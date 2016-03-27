# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  is_public     :boolean          default(TRUE)
#  can_subscribe :boolean          default(TRUE)
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
