require 'rails_helper'

RSpec.describe Email, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1', passwd: '12345678', passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@gmail.com', user_id: @user.id)
    @email_tow = Email.create!(email: 'user1@gmail.com', user_id: @user_two.id)
  end

  it 'is valid add a new email' do
    expect( Email.count_by_user(@user.id)).to eq(1)

    email = Email.add_email(@user.id, 'other_user@gmail.com')
    expect(email).to be_valid

    expect( Email.count_by_user(@user.id)).to eq(2)

    expect { Email.add_email(@user.id, 'other_user@gmail.com') }.to raise_error(/The email already exist in your account/)
  end

  it 'is valid add the email like principal' do
    expect { expect( Email.principal @user.id, @email.id) }.to raise_error('The email has to be check')

    @email.update!(checked: true)
    email = Email.principal @user.id, @email.id
    expect(email.principal).to eq(true)

  end

  it 'is valid remove an email' do

  end
end
