json.array!(@food_reviews) do |food_review|
  json.extract! food_review, :id, :rating, :comment
  json.url food_review_url(food_review, format: :json)
end
