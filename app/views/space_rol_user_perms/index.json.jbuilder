json.array!(@space_rol_user_perms) do |space_rol_user_perm|
  json.extract! space_rol_user_perm, :id, :id_user, :id_space
  json.url space_rol_user_perm_url(space_rol_user_perm, format: :json)
end
