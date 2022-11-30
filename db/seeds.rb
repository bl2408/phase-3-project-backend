puts "🌱 Seeding spices..."


# Roles
role1 = Role.create(name: "admin")
role2 = Role.create(name: "editor")
role3 = Role.create(name: "member")
Role.create(name: "public")

user1 = User.create(name: "Brian", role: role1)
user2 = User.create(name: "Alice", role: role2)
user3 = User.create(name: "Bob", role: role3)

view1 = Viewable.create(name: "public")
view2 = Viewable.create(name: "private")
view3 = Viewable.create(name: "draft")

Post.create(title: "First post!", body: "This is my first post.", viewable: view1, author: user1 )
Post.create(title: "Second post!", body: "This is my first post but is private", viewable: view2, author: user2)
Post.create(title: "Third post!", body: "This is my first post but is draft", viewable: view3, author: user3 )




puts "✅ Done seeding!"
