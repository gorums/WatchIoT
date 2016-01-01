# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create plans static values
Plan.create(name: 'Free', amount_per_month: 0)
Plan.create(name: 'Small', amount_per_month: 9)
Plan.create(name: 'Medium', amount_per_month: 19)
Plan.create(name: 'Large', amount_per_month: 29)

Feature.create(name: 'Number of spaces')
Feature.create(name: 'Number of projects by space')
Feature.create(name: 'Private spaces and projects')
Feature.create(name: 'Request per minutes')
Feature.create(name: 'Notification by email')
Feature.create(name: 'Notification by sms')
Feature.create(name: 'Webhook support')
Feature.create(name: 'Subscribe users in public spaces/projects')
Feature.create(name: 'Team members')

# Number of spaces
PlanFeature.create(plan_id: 1, feature_id: 1, value: '3')
PlanFeature.create(plan_id: 2, feature_id: 1, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 1, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 1, value: '30')

# Number of projects by space
PlanFeature.create(plan_id: 1, feature_id: 2, value: '5')
PlanFeature.create(plan_id: 2, feature_id: 2, value: '10')
PlanFeature.create(plan_id: 3, feature_id: 2, value: '15')
PlanFeature.create(plan_id: 4, feature_id: 2, value: '30')

# Private spaces and projects
PlanFeature.create(plan_id: 1, feature_id: 3, value: 'true')
PlanFeature.create(plan_id: 2, feature_id: 3, value: 'true')
PlanFeature.create(plan_id: 3, feature_id: 3, value: 'true')
PlanFeature.create(plan_id: 4, feature_id: 3, value: 'true')

# Request per minutes
PlanFeature.create(plan_id: 1, feature_id: 4, value: '1')
PlanFeature.create(plan_id: 2, feature_id: 4, value: '15')
PlanFeature.create(plan_id: 3, feature_id: 4, value: '30')
PlanFeature.create(plan_id: 4, feature_id: 4, value: '60')

# Notification by email
PlanFeature.create(plan_id: 1, feature_id: 5, value: 'true')
PlanFeature.create(plan_id: 2, feature_id: 5, value: 'true')
PlanFeature.create(plan_id: 3, feature_id: 5, value: 'true')
PlanFeature.create(plan_id: 4, feature_id: 5, value: 'true')

# Notification by sms
PlanFeature.create(plan_id: 1, feature_id: 6, value: 'false')
PlanFeature.create(plan_id: 2, feature_id: 6, value: 'true')
PlanFeature.create(plan_id: 3, feature_id: 6, value: 'true')
PlanFeature.create(plan_id: 4, feature_id: 6, value: 'true')

# Webhook support'
PlanFeature.create(plan_id: 1, feature_id: 7, value: 'false')
PlanFeature.create(plan_id: 2, feature_id: 7, value: 'true')
PlanFeature.create(plan_id: 3, feature_id: 7, value: 'true')
PlanFeature.create(plan_id: 4, feature_id: 7, value: 'true')

# Subscribe users in public spaces/projects
PlanFeature.create(plan_id: 1, feature_id: 8, value: 'unlimited')
PlanFeature.create(plan_id: 2, feature_id: 8, value: 'unlimited')
PlanFeature.create(plan_id: 3, feature_id: 8, value: 'unlimited')
PlanFeature.create(plan_id: 4, feature_id: 8, value: 'unlimited')

# Team members
PlanFeature.create(plan_id: 1, feature_id: 9, value: '1')
PlanFeature.create(plan_id: 2, feature_id: 9, value: '5')
PlanFeature.create(plan_id: 3, feature_id: 9, value: '10')
PlanFeature.create(plan_id: 4, feature_id: 9, value: 'unlimited')

# Faq static values
Faq.create(
    question: 'Watch IoT is an application on the cloud to provider a rich platform to monitor your application
                , services or internet of thing device.',
    answer: 'We have a basic plan when you pay nothing to use our service and monitor your services or devices')
Faq.create(
    question: 'What type of services can i monitor and receive alert?',
    answer: 'Of course.')
Faq.create(
    question: 'How do i configure my projects?',
    answer: 'Of course.')
Faq.create(
    question: 'What is an space?',
    answer: 'Of course.')
Faq.create(
    question: 'How much projects can i configure by spaces?',
    answer: 'Of course.')
Faq.create(
    question: 'How much people can subscribe and receive notifications?',
    answer: 'Of course.')

# Permission static values
Permission.create(category: 'space', permission: 'create_space') # Defined on team
Permission.create(category: 'space', permission: 'edit_space') # Defined on teamSpace
