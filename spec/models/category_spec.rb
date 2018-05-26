require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:books) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(40) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
