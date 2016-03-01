require 'rails_helper'

RSpec.describe Log, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com', user_id: @user.id)
  end

  it 'is valid save log' do
    expect{ Log.save_log('description', 'this description action is to big', @user.id, @user.id) }
        .to raise_error(ActiveRecord::StatementInvalid)

    Log.save_log('description', 'action', @user.id, @user.id)
    expect(Log.all.count).to eq(1)
  end
end
