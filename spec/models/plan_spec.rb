require 'rails_helper'

RSpec.describe Plan, type: :model do
  before :each do
    before_each 'planModel'
  end

  describe 'valid find plan value' do
    let(:plan) {Plan.find_by_name('Free') }

    it 'is valid find not no exist plan value' do
      value = Plan.find_plan_value(plan, 'dont exist')
      expect(value).to eq(0)
    end

    it 'is valid find plan value team members' do
      value = Plan.find_plan_value(plan, 'Team members')
      expect(value.to_i).to eq(3)
    end

    it 'is valid find plan value notifications by email' do
      value = Plan.find_plan_value(plan, 'Notification by email')
      expect(value).to eq('true')
    end
  end
end
