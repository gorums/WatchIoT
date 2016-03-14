require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name',
                         passwd: '12345678',
                         passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com',
                           user_id: @user.id)

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'reset', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'register', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'verify_email', data: 'user@watchiot.com')

    VerifyClient.create!(user_id: @user.id, token: '12345',
                         concept: 'invited', data: 'user@watchiot.com')
  end


  describe 'GET forgot' do
    it 'has a 200 status code' do
      get :forgot
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot')
    end
  end

  describe 'POST forgot notification' do
    it 'has a 200 status code' do
      post :forgot_notification
      expect(response.status).to eq(200)
      expect(response).to render_template('users/forgot_notification')
    end
  end

  describe 'GET reset' do
    it 'has a 200 status code' do
      get :reset, { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/reset')
    end
  end

  describe 'PATCH do reset' do
    it 'has a 302 status code' do
      patch :do_reset, { token: '12345' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/login')
    end
  end

  describe 'PATCH do reset bad token' do
    it 'has a 404 status code' do
      patch :do_reset, { token: '123456' }
      expect(response.status).to eq(404)
    end
  end

  describe 'GET active' do
    it 'has a 302 status code' do
      get :active, { token: '12345' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/' + @user.username)
    end
  end

  describe 'GET verify email' do
    it 'has a 200 status code' do
      get :verify_email, { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/verify_email')
    end
  end

  describe 'GET invite' do
    it 'has a 200 status code' do
      get :invite, { token: '12345' }
      expect(response.status).to eq(200)
      expect(response).to render_template('users/invited')
    end
  end

  describe 'GET do invite' do
    it 'has a 302 status code' do
      get :do_invite, { token: '12345' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/' + @user.username)
    end
  end

end
