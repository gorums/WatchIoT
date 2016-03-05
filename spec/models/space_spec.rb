require 'rails_helper'

##
# This try to test all the space model process
#
RSpec.describe Space, type: :model do
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
    PlanFeature.create(plan_id: plan.id, feature_id: fTeam.id, value: '3')

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1', passwd: '12345678', passwd_confirmation: '12345678')

    @email_two = Email.create!(email: 'user1@watchiot.com', user_id: @user_two.id, checked: true, principal: true)
  end

  it 'is valid with a namespace' do
    # it is a valid namespace
    space = Space.create!(name: 'my_space', user_id: @user.id)
    expect(space.name).to include('my_space')

    # the namespace can be nil
    space = Space.new(name: nil, user_id: @user.id)
    space.valid?
    expect(space.errors[:name]).to include('can\'t be blank')

    # the namaspace can be more than 15 characters
    space = Space.new(name:'asd aswq ert aaasdasd 324e2 3ewf dfs dfs', user_id: @user.id)
    space.valid?
    expect(space.errors[:name]).to include('is too long (maximum is 25 characters)')
  end

  it 'is valid with more than 3 spaces with a free plan' do
    params = { name: 'my_space', description: 'space description'}
    params1 = { name: 'space1', description: 'space1 description'}
    params2 = { name: 'space2', description: 'space2 description'}
    params3 = { name: 'space3', description: 'space3 description'}

    space = Space.create_new_space(params, @user, @user)
    expect(space).to be_valid

    params = { name: 'my space', description: 'space description'}
    expect { Space.create_new_space(params, @user, @user) }
        .to raise_error('You have a space with this name')

    space1 = Space.create_new_space(params1, @user, @user)
    expect(space1).to be_valid
    space2 = Space.create_new_space(params2, @user, @user)
    expect(space2).to be_valid
    expect { Space.create_new_space(params3, @user, @user) }
        .to raise_error('You can not added more spaces, please contact with us!')
  end

  it 'is valid with duplicate namespace' do
    space = Space.create(name: 'my_space', user_id: @user.id)
    expect(space).to be_valid

    expect { Space.create!(name: 'my space', user_id: @user.id) }
        .to raise_error('You have a space with this name')

    space = Space.new(name: 'my_space', user_id: @user_two.id)
    space.valid?
    expect(space).to be_valid
  end

  it 'return a format name' do
    namespace = 'aA/*\ @#&)@as'
    space = Space.create!(name: namespace, user_id: @user.id)
    expect(space.name).to include('aA_as')
  end

  it 'is valid edit description space' do
    params = { name: 'my space', description: 'my descrition'}
    space = Space.create_new_space(params, @user, @user)
    expect(space.description).to include('my descrition')

    Space.edit_space space, 'my edit descrition'
    expect(space.name).to include('my_space') # the name space can not change
    expect(space.description).to include('my edit descrition')
  end

  it 'is valid edit a namespace for duplicate them' do
    params = { name: 'my space', description: 'space description'}
    params1 = { name: 'my space1', description: 'space1 description'}

    space = Space.create_new_space(params, @user, @user)
    expect(space).to be_valid
    space1 = Space.create_new_space(params1, @user, @user)
    expect(space1).to be_valid

    expect { Space.change_space space1, 'my_space' }
        .to raise_error(/You have a space with this name/)
  end

  it 'is valid delete a space' do
    params = { name: 'space', description: 'space description'}

    expect(Space.count_by_user @user.id).to eq(0)
    space = Space.create_new_space(params, @user, @user)
    expect(space).to be_valid
    expect(Space.count_by_user @user.id).to eq(1)

    Space.delete_space(space, 'space')
    expect(Space.count_by_user @user.id).to eq(0)

    space = Space.create_new_space(params, @user, @user)
    project = Project.create!(name: 'project', space_id: space.id)

    expect { Space.delete_space(space, 'space') }
        .to raise_error('This space can not be delete because it has one or more projects associate')

    project.destroy!
    Space.delete_space(space, 'space')
    expect(Space.count_by_user @user.id).to eq(0)
  end

  it 'is valid transfer a space to a not member' do
    params = { name: 'space', description: 'space description'}
    space = Space.create_new_space(params, @user, @user)

    expect { Space.transfer(space, @user, @user_two.id) }.to raise_error('The member is not valid')
  end

  it 'is valid transfer a space to a member' do
    params = { name: 'space', description: 'space description'}
    space = Space.create_new_space(params, @user, @user)

    Team.add_member(@user, @email_two.email)
    expect { Space.transfer(space, @user, @user_two.id) }
        .to change { ActionMailer::Base.deliveries.count }.by(1)

    # user do not have space
    expect(Space.count_by_user @user.id).to eq(0)

    # user two have new space
    space = Space.find_by_user_id @user_two.id
    expect(space.name).to eq('space')

    # add a new space to the user two
    params = { name: 'space1', description: 'space description'}
    Space.create_new_space(params, @user_two, @user_two)

    # user one add a new space
    params = { name: 'space', description: 'space description'}
    space = Space.create_new_space(params, @user, @user)

    # we can not transfer a space with the same name
    expect { Space.transfer(space, @user, @user_two.id) }
        .to raise_error(/You have a space with this name/)

    # add a new space to the user two, it has now 3 space
    params = { name: 'space2', description: 'space description'}
    Space.create_new_space(params, @user_two, @user_two)

    expect { Space.transfer(space, @user, @user_two.id) }
        .to raise_error('The team member can not add more spaces, please contact with us!')
  end
end
