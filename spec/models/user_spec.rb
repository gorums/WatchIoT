require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    before_each 'userModel'
  end

  describe 'valid create new account' do
    it 'is valid username' do
      # the password is required
      user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa')
      expect(user_new).to_not be_valid

      # nil username
      user_new = User.new(username: nil)
      expect(user_new).to_not be_valid

      expect(user_new).to_not be_valid
      # the username have to be less than 25 characters
      user_new = User.create(username: 'aaaaaaabbbbDDDDaaaaaaGGGGGGsssssssqqqqqqqEEEqqqqqq',
                             passwd: 'aaadddSSaa',
                             passwd_confirmation: 'aaadddSSaa')
      expect(user_new.username).to eq('aaaaaaabbbbddddaaaaaaggg')

      user_new = User.create(username: 'aaaaaaabbbbDDDDaaaaaaggg',
                          passwd: 'aaadddSSaa',
                          passwd_confirmation: 'aaadddSSaa')
      expect(user_new).to_not be_valid
    end

    it 'is valid password' do
      # the confirmation password is required
      user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa',
                          passwd: 'aaadddSSaa')

      # the password and the confirmation have to mach
      user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa',
                          passwd: 'aaadddSSaa',
                          passwd_confirmation: 'aaaddd11aa')
      expect(user_new).to_not be_valid

      # the password has to be more than 8 characters
      user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa',
                          passwd: 'aaaddd',
                          passwd_confirmation: 'aaaddd')
      expect(user_new).to_not be_valid
    end

    it 'is valid username exist' do
      # the username exist
      expect { User.create!(username: 'my_user_name',
                            passwd: 'aaadddSSaa',
                            passwd_confirmation: 'aaadddSSaa')}
          .to raise_error(/Username has already been taken/)

      # the username exist
      expect { User.create!(username: 'my_User_NAme',
                            passwd: 'aaadddSSaa',
                            passwd_confirmation: 'aaadddSSaa')}
          .to raise_error(/Username has already been taken/)

      User.create!(username: 'my_User NAme',
                   passwd: 'aaadddSSaa',
                   passwd_confirmation: 'aaadddSSaa')

      expect { User.create!(username: 'my_User-NAme',
                            passwd: 'aaadddSSaa',
                            passwd_confirmation: 'aaadddSSaa')}
          .to raise_error(/Username has already been taken/)
    end

    it 'is valid create a new account' do
      # create a new acount
      expect { User.create_new_account('user12@watchiot.org') }
          .to change { ActionMailer::Base.deliveries.count }.by(1)

      email = Email.find_by_email 'user12@watchiot.org'
      expect(email).to_not be_nil

      expect(email.user.username).to include('user12_watchiot_org')
      expect(email.user.api_key_id).to_not be_nil
    end
  end

  describe 'valid delete account' do
    it 'is valid delete a bad account' do
      expect { User.delete_account(@user, 'my_user_name_bad') }
          .to raise_error('The username is not valid')
    end

    it 'is valid delete a nil confirmation account' do
      expect { User.delete_account(@user, nil) }
          .to raise_error('The username is not valid')
    end

    it 'is valid delete an account with spaces' do
      # you can not delete an account with space assigned
      params = { name: 'space', description: 'space description'}
      Space.create_new_space(params, @user_two, @user_two)

      expect { User.delete_account(@user_two, @user_two.username) }
          .to raise_error('You have to transfer your spaces or delete their')
    end

    it 'is valid delete account' do
      expect(@user.status).to eq(true)
      User.delete_account(@user, @user.username)
      userDisabled = User.find_by_username 'my_user_name'
      expect(userDisabled.status).to eq(false)
    end
  end

  describe 'valid change username' do
    it 'is valid change the same username' do
      # the same username
      expect {User.change_username @user, 'my_user_name'}
          .to_not raise_error
    end

    it 'is valid change username' do
      # new user name
      expect {User.change_username @user, 'new_user_name'}
          .to_not raise_error
    end

    it 'is valid change to exist username' do
      # exist username
      expect { User.change_username @user, 'my_User_Name1'}
          .to raise_error(/Username has already been taken/)

      expect {User.change_username @user_two, 'my-user_name1'}
          .to_not raise_error

      # exist username
      expect { User.change_username @user, 'my User_Name1'}
          .to raise_error(/Username has already been taken/)
    end
  end

  describe 'valid register' do
    it 'is valid register' do
      # the register was correctly
      params = { username: 'new_register_user',
                 passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user = User.find_by_username 'new_register_user'
      expect(user).to_not be_nil
      expect(user.status).to eq(false)
      expect(user.passwd_salt).to_not be_empty
      expect(user.auth_token).to_not be_empty
      expect(user.passwd.length).to be == 60 # length of hash
      expect(user.api_key_id).to_not be_nil
      expect(user.plan_id).to_not be_nil

      emails = user.emails
      email = emails.first
      expect(email).to_not be_nil
      expect(email.email).to include('newemail@watchiot.org')
      expect(email.principal).to eq(false)
      expect(email.checked).to eq(false)

    end

    it 'is valid register with exist user' do
      params = { username: 'new_register_user',
                 passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      # invalid user
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to raise_error(/Username has already been taken/)

    end

    it 'is valid register with bad email' do
      # invalid email
      params = { username: 'new_register_user1', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail_bad_watchiot.org'}
          .to raise_error(/The email is not valid/)
    end

    it 'is valid register with nil email' do
      # invalid email
      params = { username: 'new_register_user1', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, nil}
          .to raise_error(/The email is not valid/)
    end

    it 'is valid register with empty email' do
      # invalid email
      params = { username: 'new_register_user1', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, ''}
          .to raise_error(/The email is not valid/)
    end

    it 'is valid register with nil username' do
      # invalid email
      params = { username: nil, passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to raise_error(/Username is too short \(minimum is 1 character\), Username can\'t be blank/)
    end

    it 'is valid register with empty username' do
      # invalid email
      params = { username: '', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to raise_error(/Username is too short \(minimum is 1 character\), Username can\'t be blank/)
    end

    it 'is valid register with short password' do
      # password too short
      params = { username: 'new_register_user1', passwd: '123456',
                 passwd_confirmation: '123456'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to raise_error('Password has less than 8 characters')
    end

    it 'is valid register with not match passwords' do
      # passwords do not match
      params = { username: 'new_register_user1', passwd: '123456678',
                 passwd_confirmation: '123456'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to raise_error('Password does not match the confirm password')
    end
  end

  describe 'valid change password' do
    it 'is valid change password' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: '123456789999',
                 passwd_confirmation: '123456789999'}
      expect { User.change_passwd new_user, params }
          .to_not raise_error

      # no old password now is 123456789999 not 12345678
      params = { passwd: '12345678', passwd_new: '123456789999',
                 passwd_confirmation: '123456789999'}
      expect { User.change_passwd new_user, params }
          .to raise_error('The old password is not correctly')

      # the confirmation passwords do not match
      params = { passwd: '123456789999', passwd_new: '12345678',
                 passwd_confirmation: '123456789'}
      expect { User.change_passwd new_user, params }
          .to raise_error('Password does not match the confirm password')
    end

    it 'is valid change pasword to short' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: '123',
                 passwd_confirmation: '123'}
      expect { User.change_passwd new_user, params }
          .to raise_error(/Password has less than 8 characters/)
    end

    it 'is valid change nil pasword' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: nil,
                 passwd_confirmation: '123'}
      expect { User.change_passwd new_user, params }
          .to raise_error(/Password has less than 8 characters/)
    end


    it 'is valid change pasword with do not match' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      # no problem change the password
      new_user = User.find_by_username 'new_register_user'
      params = { passwd: '12345678', passwd_new: '1234567890',
                 passwd_confirmation: '0987654321'}
      expect { User.change_passwd new_user, params }
          .to raise_error(/Password does not match the confirm password/)
    end
  end

  describe 'valid login' do
    it 'is valid login into the account with status false' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      # user status is false
      expect { User.login 'new_register_user', '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login into the account with status true' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      user_login = User.login 'new_register_user', '12345678'
      expect(user_login).to_not be_nil
      expect(user_login.username).to eq('new_register_user')
    end

    it 'is valid login with bad password' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      # bad password
      expect { User.login 'new_register_user', '123456789' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with not exist account' do
      # user does not exist
      expect { User.login 'new_register_user_1', '123456789' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with not principal email' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login 'newemail@watchiot.org', '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with principal email' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      email_login = user_new.emails.first
      User.active_account(user_new, email_login)

      user_login = User.login 'newemail@watchiot.org', '12345678'
      expect(user_login).to_not be_nil
      expect(user_login.username).to eq('new_register_user')
    end

    it 'is valid login with nil username' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login nil, '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with empty username' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login '', '12345678' }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with nil password' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login 'new_register_user', nil }
          .to raise_error('Account is not valid')
    end

    it 'is valid login with empty password' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      expect { User.login 'new_register_user', '' }
          .to raise_error('Account is not valid')
    end
  end

  describe 'valid reset the password' do
    it 'is valid reset the password with not match' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      # password and confirmation do not match
      params = { passwd_new: 'new12345678',
                 passwd_confirmation: 'new12345678bad'}
      expect { User.reset_passwd user_new, params }
          .to raise_error('Password does not match the confirm password')
    end

    it 'is valid reset the password with short password' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      params = { passwd_new: '123',
                 passwd_confirmation: '123'}
      expect { User.reset_passwd user_new, params }
          .to raise_error('Password has less than 8 characters')

      params = { passwd_new: nil,
                 passwd_confirmation: '123'}
      expect { User.reset_passwd user_new, params }
          .to raise_error('Password has less than 8 characters')
    end

    it 'is valid reset the password' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      user_new = User.find_by_username 'new_register_user'
      user_new.update!(status: true)

      # does not exist email like principal, not problem
      email_login = user_new.emails.first
      expect(email_login.principal).to eq(false)
      expect(email_login.checked).to eq(false)

      params = { passwd_new: 'new12345678',
                 passwd_confirmation: 'new12345678'}
      expect { User.reset_passwd user_new, params }
          .to_not raise_error

      email_login = user_new.emails.first
      expect(email_login.principal).to eq(true)
      expect(email_login.checked).to eq(true)

      params = { passwd_new: 'new12345678',
                 passwd_confirmation: 'new12345678'}

      expect { User.reset_passwd user_new, params }
          .to change { ActionMailer::Base.deliveries.count }.by(1)

      # the pasword was change
      expect { User.login 'new_register_user', '12345678' }
          .to raise_error('Account is not valid')

      # login with the new passsword
      user_login = User.login user_new.username, 'new12345678'
      expect(user_login).to_not be_nil

    end

    it 'is valid reset the password with the account disabled' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect {User.register params, 'newemail@watchiot.org'}
          .to_not raise_error

      email = Email.find_by_email 'newemail@watchiot.org'
      user_new = User.find_by_username 'new_register_user'
      email.update!(principal: true, checked: true)
      user_new.update!(status: false)

      expect { User.login user_new.username, '12345678' }
          .to raise_error('Account is not valid')

      params = { passwd_new: 'new12345678',
                 passwd_confirmation: 'new12345678'}

      # not email is sending
      expect { User.reset_passwd user_new, params }
          .to change { ActionMailer::Base.deliveries.count }.by(0)

      # the account continue disabled
      expect(user_new.status).to eq(false)
      expect { User.login user_new.username, 'new12345678' }
          .to raise_error('Account is not valid')
    end
  end

  describe 'valid activate the account' do
    it 'is valid activate the account' do
      expect { User.active_account @user, @email }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(@user.status).to eq(true)
      expect(@email.principal).to eq(true)
      expect(@email.checked).to eq(true)
    end

    it 'is valid activate the account with not belong email' do
      expect { User.active_account @user, @email_two }
          .to raise_error('The account can not be activate')
    end
  end

  describe 'valid invited' do
    let(:user) { User.create_new_account('user12@watchiot.org') }
    let(:email) { Email.find_by_email('user12@watchiot.org') }

    it 'is valid invited with bad password' do
      # bad password
      params = { username: 'new_register_user', passwd: '12345678bad',
                 passwd_confirmation: '12345678'}
      expect { User.invite user, params, email }
          .to raise_error('Password does not match the confirm password')
    end

    it 'is valid invited with short password' do
      # short password
      params = { username: 'new_register_user', passwd: '12345',
                 passwd_confirmation: '12345'}
      expect { User.invite user, params, email }
          .to raise_error('Password has less than 8 characters')
    end

    it 'is valid invited with bad username' do
      params = { username: '', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect { User.invite user, params, email }
          .to raise_error(/Username is too short \(minimum is 1 character\)/)

      # username exist
      params = { username: @user.username, passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect { User.invite user, params, email }
          .to raise_error(/Username has already been taken/)

    end

    it 'is valid invited' do
      params = { username: 'new_register_user', passwd: '12345678',
                 passwd_confirmation: '12345678'}
      expect { User.invite user, params, email }
          .to change { ActionMailer::Base.deliveries.count }.by(2)

      expect(user.auth_token).to_not be_nil
      expect(user.status).to eq(true)
      expect(email.principal).to eq(true)
      expect(email.checked).to eq(true)
    end
  end

  describe 'valid send forgot notification' do
    it 'is valid send forgot notification user not exist' do
      expect { User.send_forgot_notification 'the user do no exist' }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(0)
    end

    it 'is valid send forgot notification email not principal' do
      # the email is not set like principal
      expect { User.send_forgot_notification @user.username }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(1)

      # the email is not set like principal buy it can recovery the password
      expect { User.send_forgot_notification @email.email }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(1)
    end

    it 'is valid send forgot notification email principal' do
      # set the email like principal
      @email.update!(principal: true, checked:true)

      expect { User.send_forgot_notification @user.username }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(1)

      expect { User.send_forgot_notification @email.email }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(1)
    end

    it 'is valid send forgot notification two account with the same email no principal' do
      # two account with the same email no principal
      user = User.create!(username: 'my_user_name_new', passwd: '12345678',
                          passwd_confirmation: '12345678')
      Email.create!(email: 'user@watchiot.com', user_id: user.id)

      # send to the first account with only one email and not principal
      expect { User.send_forgot_notification @email.email }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'is valid send forgot notification with the account disabled' do
      User.delete_account(@user, @user.username)
      expect { User.send_forgot_notification @user.username }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(0)

      expect { User.send_forgot_notification @email.email }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(0)

      @user.update!(status: true)
      # it can
      expect { User.send_forgot_notification @user.username }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(1)

      expect { User.send_forgot_notification @email.email }
          .to change { ActionMailer::Base.deliveries.count }
                  .by(1)
    end
  end

  describe 'valid omniauth' do
    it 'is valid omniauth' do
      params = { 'provider' => 'github',
                 'uid' => '12345678', 'info' =>
                     {'nickname' => 'aa', 'name' => 'aa',
                      'email' => 'omniauth@watchio.org'}}

      expect {  User.create_with_omniauth params }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
