class Space < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  validates_presence_of :name, on: :create
  validates_uniqueness_of :name, scope: [:user_id]

  validates :name, length: { maximum: 15 }

  validates :name, exclusion: { in: %w(create edit delete setting space),
                                     message: '%{value} is reserved.' }
  include ActiveModel::Validations
  validates_with SpaceCanCreateValidator, on: :create
  validates_with SpaceCanEditValidator, on: :update

  before_save :name_format

  private
  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters
  #
  def name_format
    self.name.gsub! /[^0-9a-z ]/i, '_'
    self.name.downcase.gsub! /\s+/, '_'
  end

end