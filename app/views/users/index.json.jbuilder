json.array!(@users) do |user|
  json.extract! user, :id, :passwd, :email
  json.url user_url(user, format: :json)
end
