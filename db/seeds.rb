# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all

root1 = Category.create(name: "child1")
root2 = Category.create(name: "child2")
root3 = Category.create(name: "child3")
Category.create(name: "child11", parent: root1)
Category.create(name: "child12", parent: root1)
Category.create(name: "child13", parent: root1)
child21 = Category.create(name: "child21",  parent: root2)
Category.create(name: "child211", parent: child21)
Category.create(name: "child212", parent: child21)
Category.create(name: "child22",  parent: root2)
child31 = Category.create(name: "child31",    parent: root3)
child311 = Category.create(name: "child311",   parent: child31)
child3111 = Category.create(name: "child3111",  parent: child311)
child31111 = Category.create(name: "child31111", parent: child3111)
Category.create(name: "child32", parent: root3)