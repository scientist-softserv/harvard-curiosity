# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe '#create' do
    it 'successfully creates a user' do
      expect { User.create(email: 'user@example.com', password: 'testing123') }
        .to change(User, :count).by(1)
    end
  end
end
