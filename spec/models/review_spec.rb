require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(1000) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(80) }
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..5) }
  end
end
