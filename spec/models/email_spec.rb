require 'rails_helper'

RSpec.describe Email, type: :model do
  before :each do
    # Create plans and users static values for free account

    # add plan
    Plan.create!(name: 'Free', amount_per_month: 0)

    # add two users
    @user = User.create!(username: 'my_user_name',
                         passwd: '12345678',
                         passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com',
                           user_id: @user.id)
    @email_two = Email.create!(email: 'user1@watchiot.com',
                               user_id: @user_two.id,
                               checked: true, principal: true)
  end

  it 'is valid add a new email' do
    expect( Email.count_by_user(@user.id)).to eq(1)

    # add a new email
    email = Email.add_email(@user.id, 'other_user@watchiot.com')
    expect(email).to be_valid

    email = Email.add_email(@user.id, 'othEr_useR2@watchIot.Com')
    expect(email).to be_valid
    expect(email.email).to eq('other_user2@watchiot.com')

    expect( Email.count_by_user(@user.id)).to eq(3)
  end

  it 'is valid add exists email' do
    # add a new email
    email = Email.add_email(@user.id, 'other_user@watchiot.com')
    expect(email).to be_valid

    # try to add the same email to the account
    expect { Email.add_email(@user.id, 'other_user@watchiot.com') }
        .to raise_error(/The email already exist in your account/)

    # try to add the same email to the account
    expect { Email.add_email(@user.id, 'Other_useR@watChiot.Com') }
        .to raise_error(/The email already exist in your account/)
  end

  it 'is valid add bad email' do
    # bad email
    expect { Email.add_email(@user.id, nil) }
        .to raise_error(/is not a valid email/)

    expect { Email.add_email(@user.id, 'other_use@@r@watchio@t.com') }
        .to raise_error(/is not a valid email/)
  end

  it 'is valid add email with bad user' do
    expect { Email.add_email(-1, 'other_user@watchiot.com') }
        .to raise_error(/is not a valid user id/)
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

    expect(Email.find_by_email('user@watchiot.com').principal)
        .to eq(true)

    # set this new email like principal
    new_principal = Email.principal @user.id, other_email.id

    expect(new_principal.principal).to eq(true)
    # this email can be principal
    expect(Email.find_by_email('user@watchiot.com')
               .principal).to eq(false)
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

  it 'is valid remove the unique email' do
    # you can not delete your unique email in your account
    expect { Email.remove_email @user.id, @email.id }
        .to raise_error('You can not delete the only email in your account')
  end

  it 'is valid remove an principal email' do
    @email.update!(checked: true)
    # set this email like principal
    email = Email.principal @user.id, @email.id
    expect(email.principal).to eq(true)

    # set the other email like principal
    email = Email.add_email(@user.id, 'user12@watchiot.com')
    email.update!(checked: true)

    expect { Email.remove_email @user.id, @email.id }
        .to raise_error('The email can not be principal')
  end

  it 'is valid remove an not principal email' do
    # set the other email like principal
    email = Email.add_email(@user.id, 'user12@watchiot.com')
    email.update!(checked: true)

    email = Email.principal @user.id, email.id
    expect(email.principal).to eq(true)

    expect { Email.remove_email @user.id, @email.id}
        .to_not raise_error
  end

  it 'is valid to send verification check email' do
    expect { Email.send_verify(@user.id, @email.id) }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'is valid to send verification uncheck email' do
    expect { Email.send_verify(@user_two.id, @email_two.id) }
        .to raise_error('The email has to be uncheck')
  end

  it 'is valid to checked the email like principal' do
    expect { Email.email_to_activate @user.id, 'aass@watchiot.com' }
        .to raise_error('The email is not valid')

    expect { Email.email_to_activate @user.id, @email.email }
        .to_not raise_error

    expect { Email.email_to_activate @user.id, @email_two.email }
        .to raise_error('The email is not valid')

    expect { Email.email_to_activate @user_two.id, @email_two.email }
        .to raise_error('The email is not valid')

    # add email two but like it is principal in other account
    # we can not add to activate
    Email.add_email(@user.id, @email_two.email)
    expect { Email.email_to_activate @user.id, @email_two.email }
        .to raise_error('The email is not valid')
  end

  it 'is valid checked the email' do
    expect { Email.email_to_check @user.id, 'myemail@watchiot.com' }
        .to raise_error('The email is not valid')

    email = Email.email_to_check @user.id, @email.email
    expect(email.email).to eq(@email.email)
  end

  it 'is valid find email to send forgot' do
      # only one email and one account
      email = Email.find_email_forgot @user.emails.first.email
      expect(email).to_not be_nil

      user = User.create!(username: 'my_user_name_new',
                          passwd: '12345678',
                          passwd_confirmation: '12345678')
      Email.create!(email: 'user@watchiot.com', user_id: user.id)
      # two account with the same email no principal
      email = Email.find_email_forgot @user.emails.first.email
      expect(email).to_not be_nil
      expect(email.email).to eq(@user.emails.first.email)

      # two account with the same email but @user have an email like principal
      Email.create!(email: 'user_new@watchiot.com',
                    user_id: @user.id,
                    principal: true,
                    checked: true)

      email = Email.find_email_forgot @user.emails.first.email
      expect(email).to_not be_nil
      expect(email.email).to eq(user.emails.first.email)
  end
end
