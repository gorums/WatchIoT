json.array!(@space_rols) do |space_rol|
  json.extract! space_rol, :id, :name, :description
  json.url space_rol_url(space_rol, format: :json)
end
