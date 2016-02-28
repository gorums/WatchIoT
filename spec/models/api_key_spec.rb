require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com', user_id: @user.id)
  end

  it 'is valid generate api key' do
    api_key = ApiKey.find(@user.api_key_id)

    ApiKey.generate @user

    new_api_key = ApiKey.find(@user.api_key_id)
    expect(new_api_key.api_key).to_not eq(api_key.api_key)
  end
end
