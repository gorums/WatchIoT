require 'rails_helper'

RSpec.describe Plan, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)

    # add features
    fHook = Feature.create!(name: 'Webhook support')
    fTeam = Feature.create!(name: 'Team members')
    fSpace = Feature.create!(name: 'Number of spaces')
    fNotif = Feature.create!(name: 'Notification by email')
    fPerMin = Feature.create!(name: 'Request per minutes')
    fProject = Feature.create!(name: 'Number of projects by space')


    # Number of spaces for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fSpace.id, value: '3')
    # Number of projects by space for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fProject.id, value: '5')
    # Request per minutes for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fPerMin.id, value: '1')
    # Notification by email for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fNotif.id, value: 'true')
    # Webhook support for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fHook.id, value: 'false')
    # Team members for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '3')

    # add two users
    @user = User.create!(username: 'my_user_name',
                         passwd: '12345678',
                         passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com',
                           user_id: @user.id)
  end

  describe 'valid find plan value' do
    it 'is valid find not no exist plan value' do
      plan = Plan.find_by_name('Free')
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
