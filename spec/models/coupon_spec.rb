require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:orders) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:discount) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
