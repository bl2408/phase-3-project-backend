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

# User1 posts
Post.create(title: "First public post!", body: "This is a first public post", viewable: view1, author: user1 )
Post.create(title: "First private post!", body: "This is a first private post.", viewable: view2, author: user1 )
Post.create(title: "First draft post!", body: "This is a first draft post.", viewable: view3, author: user1 )

# User2 posts
Post.create(title: "Second public post!", body: "This is a second public post", viewable: view1, author: user2)
Post.create(title: "Third private post!", body: "This is a third private post", viewable: view2, author: user2)
Post.create(title: "Second draft post!", body: "This is a first draft post", viewable: view3, author: user2)






puts "✅ Done seeding!"
