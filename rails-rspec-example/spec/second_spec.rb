require 'rails_helper'

RSpec.describe 'second spec' do
  it 'tests' do
    build(:special_user, :with_phone)
  end
end
