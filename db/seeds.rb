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
Pledge.delete_all

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
  user.account.update_attributes card_number: '342445109495238', card_holder_first_name: 'Name', card_holder_second_name: 'Second', balance: 1000
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
(2..4).each do |i|
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

(0..3).each do |i|
  projects[0].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end

(2..4).each do |i|
  projects[1].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end

(6..7).each do |i|
  projects[2].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end

(1..7).each do |i|
  projects[3].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end

(2..3).each do |i|
  projects[4].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end

(6..7).each do |i|
  projects[5].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end


(5..7).each do |i|
  projects[6].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end


(2..4).each do |i|
  projects[7].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end

(7..9).each do |i|
  projects[8].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end


(0..3).each do |i|
  projects[9].pledges.create user: users[i], amount: (10 * i), visible: true, message: "Pledge of the user number #{i}"
end