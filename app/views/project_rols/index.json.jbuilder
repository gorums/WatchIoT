json.array!(@project_rols) do |project_rol|
  json.extract! project_rol, :id, :name, :description
  json.url project_rol_url(project_rol, format: :json)
end
