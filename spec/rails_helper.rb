# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

def before_each(type_test)
    # Create plans and users static values for free account

    # add plan
    plan = Plan.create!(name: 'Free', amount_per_month: 0)

    # add features
    fHook = Feature.create!(name: 'Webhook support')
    fTeam = Feature.create!(name: 'Team members')
    fSpace = Feature.create!(name: 'Number of spaces')
    fNotif = Feature.create!(name: 'Notification by email')
    fPerMin = Feature.create!(name: 'Request per minutes')
    fProject = Feature.create!(name: 'Number of projects by space')


    # Number of spaces for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fSpace.id, value: '3')
    # Number of projects by space for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fProject.id, value: '5')
    # Request per minutes for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fPerMin.id, value: '1')
    # Notification by email for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fNotif.id, value: 'true')
    # Webhook support for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fHook.id, value: 'false')
    # Team members for free account
    PlanFeature.create(plan_id: plan.id,
                       feature_id: fTeam.id, value: '3')

    # add two users
    @user = User.create!(username: 'my_user_name',
                         passwd: '12345678',
                         passwd_confirmation: '12345678')

    @email = Email.create!(email: 'user@watchiot.com',
                           user_id: @user.id)

    @token = VerifyClient.create_token(
        @user.id, @email.email, 'verify_client') if 'verifyClientModel' == type_test

    if 'emailModel'  == type_test ||
        'spaceModel' == type_test ||
        'teamModel'  == type_test ||
        'userModel'  == type_test
      @user_two = User.create!(username: 'my_user_name1',
                               passwd: '12345678',
                               passwd_confirmation: '12345678')
      @email_two = Email.create!(email: 'user1@watchiot.com',
                                 user_id: @user_two.id,
                               checked: true, principal: true)
    end

end

