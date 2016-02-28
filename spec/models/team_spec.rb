require 'rails_helper'

RSpec.describe Team, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)
    # add features
    fHook = Feature.create!(name: 'Webhook support')
    fTema = Feature.create!(name: 'Team members')
    fSpace = Feature.create!(name: 'Number of spaces')
    fNotif = Feature.create!(name: 'Notification by email')
    fPerMin = Feature.create!(name: 'Request per minutes')
    fProject = Feature.create!(name: 'Number of projects by space')

    # Number of spaces for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fSpace.id, value: '3')
    # Number of projects by space for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fProject.id, value: '5')
    # Request per minutes for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fPerMin.id, value: '1')
    # Notification by email for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fNotif.id, value: 'true')
    # Webhook support for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fHook.id, value: 'false')
    # Team members for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fTema.id, value: '3')

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1', passwd: '12345678', passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com', user_id: @user.id, checked: true, principal: true)
    @email_two = Email.create!(email: 'user1@watchiot.com', user_id: @user_two.id, checked: true, principal: true)
  end

  it 'is valid add a new member' do
    expect { Team.add_member(@user, 'user1@watchiot.com') }
        .to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(@user.teams.length).to eq(1)
    expect(@user.teams.first.user_team_id).to eq(@user_two.id)

    expect { Team.add_member(@user, 'user@watchiot.com') }.to raise_error('The member can not be yourself')
    expect { Team.add_member(@user, 'user1@watchiot.com') }.to raise_error('The member was adding before')
  end

  it 'is valid add a new member dont register' do

  end

  it 'is valid add a new member in two account and one of they are principal' do

  end

  it 'is valid add a new member in two account and nobody of they are principal' do

  end

  it 'is valid add more that 3 members' do

  end

  it 'is valid remove a team member' do
    expect { Team.add_member(@user, 'user1@watchiot.com') }
        .to change { ActionMailer::Base.deliveries.count }.by(1)

    expect { Team.remove_member(@user, @user_two.id) }.to_not raise_error
    expect { Team.remove_member(@user, 2345) }.to raise_error('The member is not valid')
  end
end
