# frozen_string_literal: true

FactoryBot.define do
  factory :masked_role do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'insecure' }

    factory :site_admin_exhibit_admin_mask do
      after(:create) do |user, _evaluator|
        user.roles.create role: 'admin', resource: Spotlight::Site.instance, role_mask: 'admin'
      end
    end

    factory :site_admin_curator_mask do
      after(:create) do |user, _evaluator|
        user.roles.create role: 'admin', resource: Spotlight::Site.instance, role_mask: 'curator'
        user.masked_role = 'curator'
      end
    end 
  end
end
