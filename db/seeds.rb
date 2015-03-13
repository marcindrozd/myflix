# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([ { name: "Comedy" }, { name: "Drama"}, { name: "Adventure"}, { name: "Family"} ])

Video.create(title: "Futurama",
            description: "Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.",
            small_img_url: '/tmp/futurama.jpg',
            large_img_url: '/tmp/futurama_large.jpg',
            category: categories[0])

Video.create(title: "Family Guy",
            description: "In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.",
            small_img_url: '/tmp/family_guy.jpg',
            large_img_url: '/tmp/family_guy_large.jpg',
            category: categories[0])

monk = Video.create(title: "Monk",
            description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.",
            small_img_url: '/tmp/monk.jpg',
            large_img_url: '/tmp/monk_large.jpg',
            category: categories[1])

Video.create(title: "Indiana Jones and the Last Crusade",
            description: "When Dr. Henry Jones Sr. suddenly goes missing while pursuing the Holy Grail, eminent archaeologist Indiana Jones must follow in his father's footsteps and stop the Nazis.",
            small_img_url: '/tmp/indiana.jpg',
            large_img_url: '/tmp/indiana_large.jpg',
            category: categories[2])

Video.create(title: "Titanic",
            description: "A seventeen-year-old aristocrat, expecting to be married to a rich claimant by her mother, falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.",
            small_img_url: '/tmp/titanic.jpg',
            large_img_url: '/tmp/titanic_large.jpg',
            category: categories[1])

Video.create(title: "Lion King",
            description: "Lion cub and future king Simba tests his limits, supported by his family, but sometimes gets in over his head.",
            small_img_url: '/tmp/lion_king.jpg',
            large_img_url: '/tmp/lion_king_large.jpg',
            category: categories[3])

south_park = Video.create(title: "South Park",
            description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",
            small_img_url: '/tmp/south_park.jpg',
            large_img_url: '/tmp/south_park_large.jpg',
            category: categories[0])

Video.create(title: "Dinosaurs",
            description: "Dinosaurs follows the life of a family of dinosaurs, living in a modern world. They have TVs, fridges, etc. The only humans around are cavemen, who are viewed as pets and wild animals.",
            small_img_url: '/tmp/dinosaurs.jpg',
            large_img_url: '/tmp/dinosaurs_large.jpg',
            category: categories[0])

Video.create(title: "The Office",
            description: "A mockumentary on a group of typical office workers, where the workday consists of ego clashes, inappropriate behavior, and tedium. Based on the hit BBC series.",
            small_img_url: '/tmp/office.jpg',
            large_img_url: '/tmp/office_large.jpg',
            category: categories[0])

friends = Video.create(title: "Friends",
            description: "Follows the lives of six 20-something friends living in Manhattan.",
            small_img_url: '/tmp/friends.jpg',
            large_img_url: '/tmp/friends_large.jpg',
            category: categories[0])

Video.create(title: "Cars 2",
            description: "Star race car Lightning McQueen and his pal Mater head overseas to compete in the World Grand Prix race. But the road to the championship becomes rocky as Mater gets caught up in an intriguing adventure of his own: international espionage.",
            small_img_url: '/tmp/cars.jpg',
            large_img_url: '/tmp/cars_large.jpg',
            category: categories[0])


napoleon = User.create(full_name: "Napoleon Bonaparte",
            email_address: "napoleon@example.com",
            password: "password")

alice = User.create(full_name: "Alice Wonderland",
            email_address: "alice@example.com",
            password: "password")

charlie = User.create(full_name: "Charlie Brown",
            email_address: "charlie@example.com",
            password: "password")

bob = User.create(full_name: "Robert J. Bob",
            email_address: "bob@example.com",
            password: "password")

david = User.create(full_name: "David Hal",
            email_address: "david@example.com",
            password: "password")

Review.create(user: alice, video: friends, rating: "5", content: "This is the best show ever!")
Review.create(user: napoleon, video: friends, rating: "1", content: "This show is overrated.")
Review.create(user: charlie, video: monk, rating: "5", content: "I love this show.")
Review.create(user: alice, video: monk, rating: "4", content: "This is an interesting show.")
Review.create(user: napoleon, video: south_park, rating: "5", content: "This is incredibely funny.")
Review.create(user: alice, video: south_park, rating: "2", content: "I don't get this humor.")
Review.create(user: charlie, video: south_park, rating: "3", content: "Early episodes were really great.")
Review.create(user: charlie, video: friends, rating: "3", content: "It's ok.")

QueueItem.create(video: monk, user: alice, list_order: 1)
QueueItem.create(video: south_park, user: alice, list_order: 2)
QueueItem.create(video: friends, user: alice, list_order: 3)
QueueItem.create(video: monk, user: bob, list_order: 1)
QueueItem.create(video: monk, user: charlie, list_order: 1)
QueueItem.create(video: monk, user: david, list_order: 1)
QueueItem.create(video: friends, user: david, list_order: 2)

Friendship.create(user: napoleon, friend: alice)
Friendship.create(user: napoleon, friend: bob)
Friendship.create(user: napoleon, friend: david)
Friendship.create(user: napoleon, friend: charlie)
Friendship.create(user: bob, friend: alice)
Friendship.create(user: bob, friend: charlie)
Friendship.create(user: david, friend: charlie)
Friendship.create(user: charlie, friend: napoleon)
Friendship.create(user: charlie, friend: alice)
