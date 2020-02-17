FactoryBot.define do

  factory :who_role do
    role
    association :who, factory: :user
  end

end
