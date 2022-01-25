json.extract! food, :id, :name, :description, :quantity, :spoilage, :created_at, :updated_at
json.url food_url(food, format: :json)
