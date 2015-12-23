FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    address_one"hawkeye"
    address_two "court" 
    apt_num  "123"
    city  "iowa city" 
    state "IA"
    zip  "50325"
    email 'example@email.com'
    password '123456'
  end
  
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    #admin true
  end
end