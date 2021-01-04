FactoryBot.define do
  factory :rule do
    namespace_identifier { "MyString" }
    business_identifier { "MyString" }
    controller_path { "MyString" }
    controller_name { "MyString" }
    action_name { "MyString" }
    path { "MyString" }
    verb { "MyString" }
    position { 1 }
    operation { "MyString" }
  end
end
