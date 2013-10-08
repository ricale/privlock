json.array!(@categories) do |category|
  json.extract! category, :name, :parent_id, :depth, :order_in_parent
  json.url category_url(category, format: :json)
end
