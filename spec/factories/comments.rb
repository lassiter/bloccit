FactoryGirl.define do
  factory :comment do
    body RandomData.random_paragraph
    post
    user
  end #factory :post do
end #FactoryGirl.define do