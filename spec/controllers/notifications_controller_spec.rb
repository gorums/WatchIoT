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
    end
  end

  describe 'POST forgot notification' do
    it 'has a 200 status code' do
      post :forgot
      expect(response.status).to eq(200)
    end
  end

  describe 'GET reset' do
    it 'has a 200 status code' do
      get :reset, { :token => '12345' }
      expect(response.status).to eq(200)
    end
  end

  describe 'PATCH do reset' do
    it 'has a 200 status code' do
      patch :reset, { :token => '12345' }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET active' do
    it 'has a 302 status code' do
      get :active, { :token => '12345' }
      expect(response.status).to eq(302)
    end
  end

  describe 'GET verify email' do
    it 'has a 200 status code' do
      get :verify_email, { :token => '12345' }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET invite' do
    it 'has a 200 status code' do
      get :invite, { :token => '12345' }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET do invite' do
    it 'has a 200 status code' do
      get :invite, { :token => '12345' }
      expect(response.status).to eq(200)
    end
  end

end
