FactoryBot.define do
  factory :govern do
    namespace_identifier { 'panel' }
    business_identifier { 'role' }
    controller_path { "MyString" }
    controller_name { "MyString" }
    position { 1 }
  end
end
