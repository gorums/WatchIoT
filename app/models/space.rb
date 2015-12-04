class Space < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  validates_presence_of :name, :on => :create
  #validates_uniqueness_of :user_id, :name

  validates :name, length: { maximum: 15 }

  validates :name, exclusion: { in: %w(create edit delete setting space),
                                     message: '%{value} is reserved.' }
  include ActiveModel::Validations
  validates_with SpaceCanCreateValidator

  before_save :name_format

  private
  ##
  # Format name field, lowercase and '_' by space
  #
  def name_format
    self.name.downcase.gsub! /\s+/, '_'
  end

end