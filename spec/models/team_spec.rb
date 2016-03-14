require 'rails_helper'

RSpec.describe Team, type: :model do
  before :each do
    before_each 'teamModel'
  end

  it 'is valid add a new member' do
    expect { Team.add_member(@user, 'user1@watchiot.com') }
        .to change { ActionMailer::Base.deliveries.count }
                .by(1)

    expect(@user.teams.length).to eq(1)
    expect(@user.teams.first.user_team_id)
        .to eq(@user_two.id)

    expect { Team.add_member(@user, 'user@watchiot.com') }
        .to raise_error('The member can not be yourself')
    expect { Team.add_member(@user, 'user1@watchiot.com') }
        .to raise_error('The member was adding before')
    expect { Team.add_member(@user, 'bad_emailwatchiot.com') }
        .to raise_error(/is not a valid email/)
  end

  it 'is valid add a new member dont register' do
    # send two emails for register and added to the team
    expect { Team.add_member(@user, 'user_dont_exist@watchiot.com') }
        .to change { ActionMailer::Base.deliveries.count }
                .by(2)

    username = ('user_dont_exist@watchiot.com'.gsub! /[^0-9a-z\- ]/i, '_')
                   .byteslice 0 , 24
    new_user = User.find_by_username username
    expect(new_user).to be_valid
    # the new account status has to be false
    expect(new_user.status).to eq(false)

    # the email has to be not principal and unchecked
    new_email = Email.find_by_email 'user_dont_exist@watchiot.com'
    expect(new_email).to be_valid
    expect(new_email.principal).to eq(false)
    expect(new_email.checked).to eq(false)

    member = Team.find_member(@user.id, new_user.id).take
    expect(member).to be_valid

    expect(User.all.count).to eq(3)
  end

  it 'is valid add a new member of two accounts and one of they are principal' do
    user_tree = User.create!(username: 'my_user_name2',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')
    # not principal email
    email_tree = Email.create!(email: 'user1@watchiot.com',
                               user_id: user_tree.id)

    expect { Team.add_member(@user, 'user1@watchiot.com') }
        .to change { ActionMailer::Base.deliveries.count }
                .by(1)

    # the account with the principal email was add
    member = Team.find_member(@user.id, @user_two.id).take
    expect(member).to be_valid

    member_two = Team.find_member(@user.id, user_tree.id).take
    expect(member_two).to be_nil
  end

  it 'is valid add a new member in two account and nobody of they are principal' do
    user_tree = User.create!(username: 'my_user_name2',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')
    email_tree = Email.create!(email: 'user3@watchiot.com',
                               user_id: user_tree.id)

    user_four = User.create!(username: 'my_user_name3',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')
    email_four = Email.create!(email: 'user3@watchiot.com',
                               user_id: user_four.id)
    # the email has to be principal
    expect { Team.add_member(@user, 'user3@watchiot.com') }
        .to raise_error('The member can not be added')
  end

  it 'is valid add more that 3 members for the free plan' do
    user_tree = User.create!(username: 'my_user_name2',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')
    email_tree = Email.create!(email: 'user2@watchiot.com',
                               user_id: user_tree.id)

    user_four = User.create!(username: 'my_user_name3',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')
    email_four = Email.create!(email: 'user3@watchiot.com',
                               user_id: user_four.id)

    user_five = User.create!(username: 'my_user_name4',
                             passwd: '12345678',
                             passwd_confirmation: '12345678')
    email_five = Email.create!(email: 'user4@watchiot.com',
                               user_id: user_five.id)

    Team.add_member(@user, @email_two.email)
    Team.add_member(@user, email_tree.email)
    Team.add_member(@user, email_four.email)

    # only 3 member of the team in the free plan
    expect {  Team.add_member(@user, email_five.email) }
        .to raise_error('You can not added more members '\
        'to the team, please contact with us!')
  end

  it 'is valid remove a team member' do
    expect { Team.add_member(@user, 'user1@watchiot.com') }
        .to change { ActionMailer::Base.deliveries.count }
                .by(1)

    expect { Team.remove_member(@user, @user_two.id) }
        .to_not raise_error
    expect { Team.remove_member(@user, 2345) }
        .to raise_error('The member is not valid')
  end
end
