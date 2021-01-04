FactoryBot.define do
  factory :name_space do
    name { 'panel' }
    identifier { 'panel' }
    verify_organ { false }
    verify_member { false }
    verify_user { false }
  end
end
