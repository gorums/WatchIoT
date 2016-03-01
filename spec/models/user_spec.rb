require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @email = Email.create!(email: 'user@watchiot.com', user_id: @user.id)
  end

  it 'is valid create new account' do

  end

  it 'is valid delete account' do

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
