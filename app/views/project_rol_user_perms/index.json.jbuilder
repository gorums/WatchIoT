json.array!(@project_rol_user_perms) do |project_rol_user_perm|
  json.extract! project_rol_user_perm, :id, :id_user, :id_project
  json.url project_rol_user_perm_url(project_rol_user_perm, format: :json)
end
