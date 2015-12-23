users = [{:first_name => 'Dengke',
:last_name => 'Liu',
:email => 'dengkeliu92@gmail.com',
:password => 'test',
:address_one => '1234 Hawkeye Lane',
:address_two => '',
:apt_num => '',
:city => 'Iowa City',
:state => 'IA',
:zip => '52246',
:verification_code => nil,
:id => 1,
},
{:first_name => 'Kiran',
:last_name => 'Bichugatti',
:email => 'kiran.bichugatti@gmail.com',
:password => 'test',
:address_one => '1234 Hawkeye Lane',
:address_two => '',
:apt_num => '',
:city => 'Iowa City',
:state => 'IA',
:zip => '52246',
:verification_code => nil,
:id => 2},
{:first_name => 'Eric',
:last_name => 'Burns',
:email => 'eric-burns@uiowa.edu',
:password => 'test',
:address_one => '170 Hawkeye Court',
:address_two => '',
:apt_num => '145',
:city => 'Iowa City',
:state => 'IA',
:zip => '52246',
:verification_code => nil,
:id => 3},
{:first_name => 'Avinash',
:last_name => 'Talreja',
:email => 'avinash-talreja@uiowa.edu',
:password => 'test',
:address_one => '210 Second Avenue',
:address_two => '',
:apt_num => '',
:city => 'New York',
:state => 'NY',
:zip => '10017',
:verification_code => nil,
:id => 4}]

users.each do |user_hash|
  u = User.new(user_hash)
  u.save
end

foods = [{:user_id => 3,
    :name => "Pepperoni Pizza",
    :category => "Italian",
    :description => "A delicious homemade pizza",
    :id => 1
},
{:user_id => 2,
    :name => "Spaghetti",
    :category => "Italian",
    :description => "A big heap of pasta",
    :id => 2
},
{:user_id => 3,
    :name => "Bacon Cheesburger",
    :category => "American",
    :description => "Grilled American cheeseburger",
    :id => 3
},
{:user_id => 1,
    :name => "Blueberry Muffins",
    :category => "American",
    :description => "Fluffy, homemade muffins.",
    :id => 4
},
{:user_id => 1,
    :name => "New York Cheesecake",
    :category => "American",
    :description => "Firm, sweet cheesecake",
    :id => 5
}]

portions = [{
    :food_item_id => 1,
    :portion => "12 Inch",
    :price => 10.00,
    :id => 1
},
{:food_item_id => 2,
    :portion => "1 pound",
    :price => 12.99,
    :id => 2
},
{:food_item_id => 3,
    :portion => "Quarter Pounder",
    :price => 7.99,
    :id => 3
},
{:food_item_id => 3,
    :portion => "Half Pounder",
    :price => 12.99,
    :id => 6
},
{:food_item_id => 4,
    :portion => "One Dozen",
    :price => 5.00,
    :id => 4
},
{:food_item_id => 5,
    :portion => "14 inch",
    :price => 21.50,
    :id => 5
}]

foods.each do |food|
    FoodItem.create(food)
end

portions.each do |p|
    FoodItemPortion.create(p)
end

orders = [{
       :customer_id => 1,
       :seller_id   => 3,
       :food_item_portion_id => 1,
       :price_per_portion => 4.5,
       :quantity => 5,
       :status   => 1,
       :accepted_time => '11/11/2015 01:19 PM' },
       {
       :customer_id => 3,
       :seller_id   => 2,
       :food_item_portion_id => 2,
       :price_per_portion => 7.99,
       :quantity => 2,
       :status   => 1,
       :accepted_time => '11/11/2015 01:31 PM' }]
       
orders.each do |order_hash|
  o = Order.new(order_hash)
  o.save
end