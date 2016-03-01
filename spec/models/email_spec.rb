require 'rails_helper'

RSpec.describe Email, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1', passwd: '12345678', passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com', user_id: @user.id)
    @email_two = Email.create!(email: 'user1@watchiot.com', user_id: @user_two.id, checked: true, principal: true)
  end

  it 'is valid add a new email' do
    expect( Email.count_by_user(@user.id)).to eq(1)

    # add a new email
    email = Email.add_email(@user.id, 'other_user@watchiot.com')
    expect(email).to be_valid

    expect( Email.count_by_user(@user.id)).to eq(2)

    # try to add the same email to the account
    expect { Email.add_email(@user.id, 'other_user@watchiot.com') }
        .to raise_error(/The email already exist in your account/)
  end

  it 'is valid add the email like principal' do
    expect { expect( Email.principal @user.id, @email.id) }
        .to raise_error('The email has to be check')

    # set like checked
    @email.update!(checked: true)
    # set this email like principal
    email = Email.principal @user.id, @email.id
    expect(email.principal).to eq(true)

    # add other email to the account
    other_email = Email.add_email(@user.id, 'other_user@watchiot.com')
    other_email.update!(checked: true)

    expect(Email.find_by_email('user@watchiot.com').principal).to eq(true)

    # set this new email like principal
    new_principal = Email.principal @user.id, other_email.id

    expect(new_principal.principal).to eq(true)
    # this email can be principal
    expect(Email.find_by_email('user@watchiot.com').principal).to eq(false)
  end

  it 'is valid add the email like principal being principal in other account' do
    # set user1@watchiot.com like principal in the two account
    @email_two.update!(checked: true, principal: true)

    email = Email.add_email(@user.id, 'user1@watchiot.com')
    email.update!(checked: true)

    # try to set like principal an email principal in other account
    expect { Email.principal @user.id, email.id }
        .to raise_error('The email is principal in other account')
  end

  it 'is valid remove an email' do
    # you can not delete your unique email in your account
    expect { Email.remove_email @user.id, @email.id }
        .to raise_error('You can not delete the only email in your account')

    @email.update!(checked: true)
    # set this email like principal
    email = Email.principal @user.id, @email.id
    expect(email.principal).to eq(true)

    # set the other email like principal
    email = Email.add_email(@user.id, 'user12@watchiot.com')
    email.update!(checked: true)
    expect { Email.remove_email @user.id, @email.id }
        .to raise_error('The email can not be principal')

    email = Email.principal @user.id, email.id
    expect(email.principal).to eq(true)

    expect { Email.remove_email @user.id, @email.id}.to_not raise_error
  end

  it 'is valid to send verification' do
    expect { Email.send_verify(@user.id, @email.id) }
        .to change { ActionMailer::Base.deliveries.count }.by(1)

    expect { Email.send_verify(@user_two.id, @email_two.id) }
        .to raise_error('The email has to be uncheck')
  end

  it 'is valid to checked the email like principal' do
    expect { Email.email_to_activate @user.id, 'aass@watchiot.com' }
        .to raise_error('The email is not valid')
    expect { Email.email_to_activate @user_two.id, @email_two.email }
        .to_not raise_error
  end

  it 'is valid checked the email' do
    expect { Email.email_to_check @user.id, 'myemail@watchiot.com' }
        .to raise_error('The email is not valid')

    email = Email.email_to_check @user.id, @email.email
    expect(email.email).to eq(@email.email)
  end
end
