json.array!(@writings) do |writing|
  json.extract! writing, :title, :content
  json.url writing_url(writing, format: :json)
end
