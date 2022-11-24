puts "🌱 Seeding spices..."


# Roles
role1 = Role.create(name: "admin")
role2 = Role.create(name: "editor")
role3 = Role.create(name: "member")
Role.create(name: "public")

User.create(name: "Brian", role: role1)
User.create(name: "Alice", role: role2)
User.create(name: "Bob", role: role3)

Post.create(title: "First post!", body: "This is my first post.")


puts "✅ Done seeding!"
