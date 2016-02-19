require 'rails_helper'

RSpec.describe Space, type: :model do
  before :each do
    @user = User.create!(username: 'my_user_name', passwd: '12345678', passwd_confirmation: '12345678')
    @user_two = User.create!(username: 'my_user_name1', passwd: '12345678', passwd_confirmation: '12345678')
  end

  it 'is valid with a namespace' do
    space = Space.new(name: 'my_space', user_id: @user.id)
    expect(space).to be_valid
  end

  it 'is valid with duplicate namespace' do
    space = Space.create(name: 'my_space', user_id: @user.id)
    expect(space).to be_valid

    space = Space.new(name: 'my_space', user_id: @user.id)
    space.valid?
    expect(space.errors[:name]).to include('has already been taken')

    space = Space.new(name: 'my_space', user_id: @user_two.id)
    space.valid?
    expect(space).to be_valid
  end

  it 'return a format name'
  it 'is valid with more than 3 spaces with a free plan'
  it 'is valid edit a namespace'
  it 'is valid edit a namespace for duplicate them'
  it 'is valid delete a space'
  it 'is valid transfer a space to a member'
  it 'is valid transfer a space to a not member'
end
