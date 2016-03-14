require 'rails_helper'

RSpec.describe VerifyClient, type: :model do
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
                               checked: true,
                               principal: true)
  end

  describe 'valid create a token' do
    it 'is valid create a token' do
      token = VerifyClient.create_token @user.id,
                                        @email.email,
                                        'verify_client'

      expect(token.length).to eq(36)

      verifyClient = VerifyClient.find_by_concept 'verify_client'
      expect(verifyClient.data).to include(@email.email)

      verifyClient = VerifyClient.find_by_concept 'concept_not_exist'
      expect(verifyClient).to be_nil
    end
  end
end
