# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Project.delete_all
Vote.delete_all

admins = []
5.times do |i|
  admins << User.new(email: "admin#{i}@mail.ua", password: 'valid_password', admin: true)
end
admins.each do |admin|
  admin.save
end

users = []
10.times do |i|
  users << User.create(email: "user#{i}@mail.ua", password: 'valid_password')
end
users.each do |user|
  user.save
end

projects = []
projects << Project.new(user: users[0], title: "Project0", description: "Project0 long description here", main_picture: "Pic0.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ", realization_duration: 4, goal: 100, published: true, published_at: 1.minute.ago)
projects << Project.new(user: users[0], title: "Project1", description: "Project1 long description here", main_picture: "Pic1.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ", realization_duration: 8, goal: 200, published: true, published_at: 1.minute.ago)
(3..6).each do |i|
  projects << Project.new(user: users[1], title: "Project#{i}", description: "Project#{i} long description here", main_picture: "Pic#{i}.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ", realization_duration: 3, goal: 100, published: true, published_at: 1.minute.ago)
end
(7..10).each do |i|
  projects << Project.new(user:users[2], title: "Project#{i}", description: "Project#{i} long description here", main_picture: "Pic#{i}.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ", realization_duration: 3, goal: 100, published: true, published_at: 1.minute.ago)
end
projects.each do |project|
  project.save
end
projects[0].updates.create title: "Project0 Update0", description: "Project0 Update0 long description here", main_picture: "Pic0.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ"
projects[0].updates.create title: "Project0 Update1", description: "Project0 Update1 long description here", main_picture: "Pic0.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ"
projects[1].updates.create title: "Project1 Update0", description: "Project1 Update0 long description here", main_picture: "Pic0.jpg", main_video: "https://youtu.be/8nTFjVm9sTQ"

4.times do |i|
  projects[0].comments.create user: users[i], content: "Comment text #{i}"
end
3.times do |i|
  projects[1].comments.create user: users[i], content: "Comment text #{i}"
end
projects[0].updates.last.comments.create user: users[0], content: "Comment text"
projects[1].updates.last.comments.create user: users[1], content: "Comment text"
users[0].comments.create user: users[1], content: "Comment text"
users[0].comments.create user: users[2], content: "Comment bla bla"

5.times do |i|
  projects[0].votes.create user: users[i]
  projects[0].votes.create user: admins[i], status: Vote.statuses[:disliked], group: Vote.groups[:admins]
end
5.times do |i|
  projects[1].votes.create user: users[i], status: Vote.statuses[:disliked]
  projects[1].votes.create user: admins[i], group: Vote.groups[:admins]
end
5.times do |i|
  projects[2].votes.create user: users[i], status: Vote.statuses[:disliked]
  projects[2].votes.create user: admins[i], status: Vote.statuses[:disliked], group: Vote.groups[:admins]
end
3.times do |i|
  projects[3].votes.create user: users[i]
  projects[3].votes.create user: admins[i], group: Vote.groups[:admins]
end
8.times do |i|
  projects[4].votes.create user: users[i]
end
(8..9).each do |i|
  projects[4].votes.create user: users[i], status: Vote.statuses[:disliked]
end
(3..7).each do |i|
  projects[5].votes.create user: users[i]
end
(2..5).each do |i|
  projects[6].votes.create user: admins[i], status: Vote.statuses[:disliked], group: Vote.groups[:admins]
end
(1..4).each do |i|
  projects[7].votes.create user: admins[i], group: Vote.groups[:admins]
  projects[7].votes.create user: users[i]
end
(5..9).each do |i|
  projects[8].votes.create user: users[i]
end
(1..4).each do |i|
  projects[8].votes.create user: users[i], status: Vote.statuses[:disliked]
  projects[8].votes.create user: admins[i], group: Vote.groups[:admins]
end
(1..2).each do |i|
  projects[9].votes.create user: users[i], status: Vote.statuses[:disliked]
end
(3..8).each do |i|
  projects[9].votes.create user: users[i]
end