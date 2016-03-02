require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1', passwd: '12345678', passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com', user_id: @user.id)
  end

  it 'is valid create new account' do
    # the password is required
    user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa')
    expect(user_new).to_not be_valid

    # the confirmation password is required
    user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa', passwd: 'aaadddSSaa')
    expect(user_new).to_not be_valid

    # the password and the confirmation have to mach
    user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa', passwd: 'aaadddSSaa', passwd_confirmation: 'aaaddd11aa')
    expect(user_new).to_not be_valid

    # the password have to be more than 8 characters
    user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa', passwd: 'aaaddd', passwd_confirmation: 'aaaddd')
    expect(user_new).to_not be_valid

    # the username have to be less than 25 characters
    user_new = User.create(username: 'aaaaaaabbbbDDDDaaaaaaGGGGGGsssssssqqqqqqqEEEqqqqqq', passwd: 'aaadddSSaa', passwd_confirmation: 'aaadddSSaa')
    expect(user_new.username).to include('aaaaaaabbbbDDDDaaaaa')

    user_new = User.new(username: 'aaaaaaabbbbDDDDaaaaaa', passwd: 'aaadddSSaa', passwd_confirmation: 'aaadddSSaa')
    expect(user_new).to be_valid

    # create a new acount
    expect { User.create_new_account('user12@watchiot.org') }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    email = Email.find_by_email 'user12@watchiot.org'
    expect(email).to_not be_nil

    expect(email.user.username).to include('user12_watchiot_org')
  end

  it 'is valid delete account' do
    expect { User.delete_account(@user, 'my_user_name_bad') }
        .to raise_error('The username is not valid')

    # you can not delete an account with space assigned
    params = { name: 'space', description: 'space description'}
    Space.create_new_space(params, @user_two, @user_two)

    expect { User.delete_account(@user_two, @user_two.username) }
        .to raise_error('You have to transfer or your spaces or delete their')

    # when i delete the account the status change to false
    expect(@user.status).to eq(true)
    User.delete_account(@user, @user.username)
    userDisabled = User.find_by_username 'my_user_name'
    expect(userDisabled.status).to eq(false)

  end

  it 'is valid change username' do

  end

  it 'is valid change password' do

  end

  it 'is valid authenticate' do

  end

  it 'is valid register' do

  end

  it 'is valid login' do

  end

  it 'is valid omniauth' do

  end

  it 'is valid reset the password' do

  end

  it 'is valid activate the account' do

  end

  it 'is valid invited' do

  end

  it 'is valid send forgot notification' do

  end
end
