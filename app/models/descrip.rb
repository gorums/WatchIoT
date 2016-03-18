# == Schema Information
#
# Table name: descrips
#
#  id          :integer          not null, primary key
#  description :string
#  icon        :string
#  lang        :string           default("en")
#  title       :string
#

##
# Descrip model
#
class Descrip < ActiveRecord::Base
end
