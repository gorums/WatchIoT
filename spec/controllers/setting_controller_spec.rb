require 'rails_helper'

RSpec.describe SettingController, type: :controller do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

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

  end

  describe 'GET user setting' do
    it 'has a 200 status code' do
      get :show, username: 'user_name'
      expect(response.status).to eq(200)
    end
  end

  describe 'GET user setting unauthorized' do
    it 'has a 401 status code' do
      get :show, username: 'user_name_unauthorized'
      expect(response.status).to eq(401)
    end
  end

  describe 'GET not found user setting' do
    it 'has a 404 status code' do
      get :show, username: 'user_name_not_exist'
      expect(response.status).to eq(404)
    end
  end

  describe 'Patch profile setting' do
    it 'has a 302 status code' do
      patch :profile, username: 'user_name',
            user: {first_name: 'User', last_name: 'Name'}

      expect(response.status).to eq(302)

      user = User.find_by_username 'user_name'
      expect(user.first_name).to eq('User')
      expect(user.last_name).to eq('Name')
    end
  end

  describe 'Post add email setting' do
    it 'has a 302 status code' do
      post :account_add_email, username: 'user_name',
            email: {email: 'my_new_email@watchiot.org'}
      expect(response.status).to eq(302)

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(2)
    end
  end

  describe 'Delete add email setting' do
    it 'has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email@watchiot.org'}

      email = Email.find_by_email 'my_new_email@watchiot.org'

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(2)

      delete :account_remove_email, username: 'user_name', id: email.id
      expect(response.status).to eq(302)

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(1)
    end
  end

  describe 'Post add email like principal setting' do
    it 'has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email@watchiot.org'}

      email = Email.find_by_email 'my_new_email@watchiot.org'
      Email.email_verify email
      expect(email.checked).to be(true)

      get :account_principal_email, username: 'user_name',
           id: email.id
      expect(response.status).to eq(302)

      user = User.find_by_username 'user_name'
      expect(user.emails.length).to eq(2)

      email = Email.find_by_email 'user@watchiot.com'
      expect(email.principal).to be(false)

      email = Email.find_by_email 'my_new_email@watchiot.org'
      expect(email.principal).to be(true)
    end
  end

  describe 'Get send email verify setting' do
    it 'has a 302 status code' do
      post :account_add_email, username: 'user_name',
           email: {email: 'my_new_email@watchiot.org'}

      email = Email.find_by_email 'my_new_email@watchiot.org'

      post :account_verify_email, username: 'user_name',
           id: email.id
      expect(response.status).to eq(302)
    end
  end

  describe 'Patch change password setting' do
    it 'has a 302 status code' do
      patch :account_ch_password, username: 'user_name',
           user: {passwd: '12345678', passwd_new: '87654321',
                     passwd_confirmation: '87654321'}

      expect { User.login 'user@watchiot.com', '12345678' }
          .to raise_error('Account is not valid')

      expect { User.login 'user@watchiot.com', '87654321' }
          .to_not raise_error
    end
  end

  describe 'Patch change username setting' do
    it 'has a 302 status code' do
      patch :account_ch_username, username: 'user_name',
            user: {username: 'new_user_name'}

      user = User.find_by_username 'user_name'
      expect(user).to be_nil
      user = User.find_by_username 'new_user_name'
      expect(user).to_not be_nil
    end
  end

  describe 'Delete account setting' do
    it 'has a 302 status code' do
      user = User.find_by_username 'user_name'
      expect(user.status).to be(true)

      delete :account_delete, username: 'user_name',
            user: {username: 'user_name'}

      user = User.find_by_username 'user_name'
      expect(user.status).to be(false)
    end
  end

  describe 'Post add member setting' do
    it 'has a 302 status code' do
      post :team_add, username: 'user_name',
            email: {email: 'user_unauthorized@watchiot.com'}

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)
    end
  end

  describe 'Delete remove member setting' do
    it 'has a 302 status code' do
      post :team_add, username: 'user_name',
           email: {email: 'user_unauthorized@watchiot.com'}

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(1)

      delete :team_delete, username: 'user_name',
           id: user.teams.first.user_team_id

      user = User.find_by_username 'user_name'
      expect(user.teams.length).to eq(0)
    end
  end

  describe 'Patch key generation setting' do
    it 'has a 302 status code' do
      user = User.find_by_username 'user_name'
      api = user.api_key.api_key

      patch :key_generate, username: 'user_name'

      user = User.find_by_username 'user_name'
      new_api = user.api_key.api_key

      expect(api).to_not eq(new_api)
    end
  end
end
