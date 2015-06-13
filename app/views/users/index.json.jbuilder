json.array!(@users) do |user|
  json.extract! user, :id, :login, :passwd, :email
  json.url user_url(user, format: :json)
end
