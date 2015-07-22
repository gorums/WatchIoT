# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


password_salt = BCrypt::Engine.generate_salt
password_hash = BCrypt::Engine.hash_secret("passwd", password_salt)

User.create(email: "admin@watchiot.com", login: "admin", passwd: password_hash)

SpaceRol.create(name: "admin", description: "Space admin rol" )
ProjectRol.create(name: "admin", description: "Project admin rol" )

SpacePerm.create(name: "create project", description: "Can create new projects")
ProjectPerm.create(name: "edit project", description: "Can edit the projects")

