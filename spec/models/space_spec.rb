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
  end

  it 'is valid with a namespace' do
    # it is a valid namespace
    space = Space.new(name: 'my_space', user_id: @user.id)
    expect(space).to be_valid

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
    params = { name: 'space', description: 'space description'}
    params1 = { name: 'space1', description: 'space1 description'}
    params2 = { name: 'space2', description: 'space2 description'}
    params3 = { name: 'space3', description: 'space3 description'}

    space = Space.create_new_space(params, @user, @user)
    expect(space).to be_valid
    space1 = Space.create_new_space(params1, @user, @user)
    expect(space1).to be_valid
    space2 = Space.create_new_space(params2, @user, @user)
    expect(space2).to be_valid
    expect { Space.create_new_space(params3, @user, @user) }.to raise_error('You can not added more spaces, please contact with us!')
  end

  it 'is valid with duplicate namespace' do
    space = Space.create(name: 'my_space', user_id: @user.id)
    expect(space).to be_valid

    space = Space.new(name: 'my_space', user_id: @user.id)
    space.valid?
    expect(space.errors[:name]).to include('You have a space with this name')

    space = Space.new(name: 'my_space', user_id: @user_two.id)
    space.valid?
    expect(space).to be_valid
  end

  it 'return a format name' do
    namespace = 'aA/*\ @#&)@as'
    space = Space.create!(name: namespace, user_id: @user.id)
    expect(space.name).to include('aA_as')
  end

  it 'is valid edit a namespace' do
    params = { name: 'my space', description: 'my descrition'}
    space = Space.create_new_space(params, @user, @user)
    expect(space.description).to include('my descrition')

    Space.edit_space 'my edit descrition', space
    expect(space.name).to include('my_space') # the name space can not change
    expect(space.description).to include('my edit descrition')
  end

  it 'is valid edit a namespace for duplicate them' do
    params = { name: 'space', description: 'space description'}
    params1 = { name: 'space1', description: 'space1 description'}

    space = Space.create_new_space(params, @user, @user)
    expect(space).to be_valid
    space1 = Space.create_new_space(params1, @user, @user)
    expect(space1).to be_valid

    expect { Space.change_space 'space', space1 }.to raise_error(/You have a space with this name/)
  end
  it 'is valid delete a space'
  it 'is valid transfer a space to a member'
  it 'is valid transfer a space to a not member'
end
