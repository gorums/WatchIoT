# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  is_public     :boolean          default(TRUE)
#  can_subscribe :boolean          default(TRUE)
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe SpacesController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)

    fSpace = Feature.create!(name: 'Number of spaces')
    fTeam = Feature.create!(name: 'Team members')

    # Number of spaces for free account
    PlanFeature.create(plan_id: plan.id, feature_id: fSpace.id, value: '3')

    # Team members for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '3')

    params = { username: 'user_name',
               passwd: '12345678',
               passwd_confirmation: '12345678'}

    User.register params, 'user@watchiot.com'

    user_new = User.find_by_username 'user_name'
    email_login = user_new.emails.first
    User.active_account(user_new, email_login)

    @user = User.login 'user@watchiot.com', '12345678'
    request.cookies[:auth_token] = @user.auth_token

    params = { username: 'user_name_unauthorized',
               passwd: '12345678',
               passwd_confirmation: '12345678'}

    User.register params, 'user_unauthorized@watchiot.com'

    user_new = User.find_by_username 'user_name_unauthorized'
    email_login = user_new.emails.first
    User.active_account(user_new, email_login)

    params = { name: 'my_space',
               description: 'space description'}
    Space.create_new_space params, @user, @user
  end

  describe 'GET all spaces' do
    it 'has a 200 status code' do
      get :index, username: 'user_name'
      expect(assigns[:spaces].length).to eq(1)
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show space' do
    it 'has a 200 status code' do
      get :show, username: 'user_name', namespace: 'my_space'
      expect(assigns[:project]).to_not be_nil
      expect(response.status).to eq(200)
    end
  end

  describe 'GET show not exist space' do
    it 'has a 404 status code' do
      get :show, username: 'user_name', namespace: 'my_space_not_exist'
      expect(response.status).to eq(404)
    end
  end

  describe 'POST create space' do
    it 'has a 302 status code' do
      post :create, username: 'user_name', space: {name: 'my_new space',
                                                   description: 'my description'}
      spaces = Space.all
      expect(spaces.length).to eq(2)
      expect(spaces.last.name).to eq('my_new-space')
      expect(response.status).to eq(302)
    end
  end

  describe 'PATCH edit space' do
    it 'has a 200 status code' do
      patch :edit, username: 'user_name', namespace: 'my_space',
            space: {description: 'my new description'}
      space = Space.first
      expect(space.description).to eq('my new description')
      expect(assigns[:project]).to_not be_nil
      expect(response.status).to eq(200)
    end
  end

  describe 'GET setting space' do
    it 'has a 200 status code' do
      get :setting, username: 'user_name', namespace: 'my_space'
      expect(assigns[:teams]).to_not be_nil
      expect(response.status).to eq(200)
    end
  end

  describe 'PATCH change name space setting' do
    it 'has a 302 status code' do
      patch :change, username: 'user_name', namespace: 'my_space',
            space: {name: 'my_new space', description: 'my new description'}
      space = Space.first
      expect(space.name).to eq('my_new-space')
      expect(space.description).to_not eq('my new description')
      expect(response.status).to eq(302)
    end
  end

  describe 'PATCH transfer space setting no member' do
    it 'has a 302 status code' do
      patch :transfer, username: 'user_name', namespace: 'my_space',
            user_member_id: '1'

      expect(flash[:error]).to eq('The member is not valid')

      space = Space.first
      expect(space).to_not be_nil

      expect(response.status).to eq(302)
    end
  end

  describe 'PATCH transfer space setting member' do
    it 'has a 302 status code' do
      Team.add_member(@user, 'user_unauthorized@watchiot.com')
      user_new = User.find_by_username 'user_name_unauthorized'
      patch :transfer, username: 'user_name', namespace: 'my_space',
            user_member_id: user_new.id

      space = Space.find_by_user_id(@user.id)
      expect(space).to be_nil

      expect(response.status).to eq(302)
    end
  end

  describe 'DELETE space setting' do
    it 'has a 302 status code' do
      delete :delete, username: 'user_name', namespace: 'my_space',
            space: {:name => 'my_space'}
      space = Space.first
      expect(space).to be_nil
      expect(response.status).to eq(302)
    end
  end

end
