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

Video.create(title: "Monk",
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

Video.create(title: "South Park",
            description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",
            small_img_url: '/tmp/south_park.jpg',
            large_img_url: '/tmp/south_park_large.jpg',
            category: categories[0])
