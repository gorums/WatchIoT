# == Schema Information
#
# Table name: faqs
#
#  id       :integer          not null, primary key
#  question :string
#  answer   :string
#  lang     :string           default("en")
#

##
# Faq model
#
class Faq < ActiveRecord::Base
end
