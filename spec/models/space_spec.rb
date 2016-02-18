require 'rails_helper'

RSpec.describe Space, type: :model do
  it 'is valid with a namespace' do
    space = Space.new(name: 'my_space')
    expect(space).to be_valid
  end
  it 'return a format name'
  it 'is valid with duplicate namespace'
  it 'is valid with more than 3 spaces with a free plan'
  it 'is valid edit a namespace'
  it 'is valid edit a namespace for duplicate them'
  it 'is valid delete a space'
  it 'is valid transfer a space to a member'
  it 'is valid transfer a space to a not member'
end
