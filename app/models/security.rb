# == Schema Information
#
# Table name: securities
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  ip             :string
#  user_id        :integer
#  user_action_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

##
# Security model
#
class Security < ActiveRecord::Base
  belongs_to :user
end
