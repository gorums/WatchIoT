# == Schema Information
#
# Table name: faqs
#
#  id       :integer          not null, primary key
#  lang     :string           default("en")
#  question :string
#  answer   :text
#

##
# Faq model
#
class Faq < ActiveRecord::Base
end
