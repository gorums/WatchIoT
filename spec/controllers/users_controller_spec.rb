require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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

    params = { username: 'user_name2',
               passwd: '12345678',
               passwd_confirmation: '12345678'}

    User.register params, 'user2@watchiot.com'
  end


  describe 'GET register' do
    it 'has a 200 status code' do
      get :register
      expect(response.status).to eq(200)
      expect(response).to render_template('register')
    end
  end

  describe 'POST register' do
    it 'has a 200 status code' do
      post :do_register,
          user: {username: 'my_user',
                 passwd: '12345678',
                 passwd_confirmation: '12345678'},
          email: {email: 'myemail@watchiot.org'}
      expect(response.status).to eq(200)
      expect(response).to render_template('need_verify_notification')
    end
  end

  describe 'POST bad register' do
    it 'has a 200 status code' do
      post :do_register,
           user: {username: 'my_user',
                  passwd: '12345678',
                  passwd_confirmation: '1234567823'},
           email: {email: 'myemail@watchiot.org'}
      expect(response.status).to eq(200)
      expect(response).to render_template('register')
      expect(flash[:error])
          .to eq('Password does not match the confirm password')
    end
  end

  describe 'GET login' do
    it 'has a 200 status code' do
      get :login
      expect(response.status).to eq(200)
      expect(response).to render_template('login')
    end
  end

  describe 'POST login' do
    it 'has a 302 status code' do
      get :do_login, user: {username: 'user_name',
                           passwd: '12345678' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name')
    end
  end

  describe 'POST login with email' do
    it 'has a 302 status code' do
      get :do_login, user: {username: 'user@watchiot.com',
                            passwd: '12345678' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/user_name')
    end
  end

  describe 'POST login bad password' do
    it 'has a 200 status code' do
      get :do_login, user: {username: 'user@watchiot.com',
                            passwd: '1234567891' }

      expect(response.status).to eq(200)
      expect(response).to render_template('login')
      expect(flash[:error])
          .to eq('Account is not valid')
    end
  end

  describe 'POST login bad username' do
    it 'has a 200 status code' do
      get :do_login, user: { username: 'my_user_name_new',
                            passwd: '12345678' }

      expect(response.status).to eq(200)
      expect(response).to render_template('login')
      expect(flash[:error])
          .to eq('Account is not valid')
    end
  end

  describe 'POST login bad email' do
    it 'has a 200 status code' do
      get :do_login, user: { username: 'my_user_name_new@watchiot.org',
                             passwd: '12345678' }

      expect(response.status).to eq(200)
      expect(response).to render_template('login')
      expect(flash[:error])
          .to eq('Account is not valid')
    end
  end

  describe 'POST login user inactive username' do
    it 'has a 200 status code' do
      get :do_login, user: { username: 'user_name2',
                             passwd: '12345678' }

      expect(response.status).to eq(200)
      expect(response).to render_template('login')
      expect(flash[:error])
          .to eq('Account is not valid')
    end
  end

  describe 'POST login user inactive email' do
    it 'has a 200 status code' do
      get :do_login, user: { username: 'user2@watchiot.com',
                             passwd: '12345678' }

      expect(response.status).to eq(200)
      expect(response).to render_template('login')
      expect(flash[:error])
          .to eq('Account is not valid')
    end
  end

  describe 'GET logout' do
    it 'has a 302 status code' do
      get :logout
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/')
    end
  end
end
