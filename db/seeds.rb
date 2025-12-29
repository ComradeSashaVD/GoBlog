# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Создаем админа
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.username = 'admin'
  user.full_name = 'Администратор'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.admin = true
end

puts "Админ создан: #{admin.username}"

# Создаем обычных пользователей
5.times do |i|
  user = User.find_or_create_by!(email: "user#{i}@example.com") do |u|
    u.username = "user#{i}"
    u.full_name = "Пользователь #{i}"
    u.password = 'password'
    u.password_confirmation = 'password'
    u.admin = false
  end

  puts "Пользователь создан: #{user.username}"

  # Создаем посты (только если их нет)
  3.times do |j|
    post_title = "Пост #{j} от #{user.username}"

    unless user.posts.exists?(title: post_title)
      post = user.posts.create!(
        title: post_title,
        content: "Это пример поста #{j} от пользователя #{user.username}. " * 10
      )

      puts "  Пост создан: #{post.title}"

      # Добавляем комментарии от других пользователей
      User.where.not(id: user.id).limit(2).each do |commenter|
        unless post.comments.exists?(user: commenter, content: "Интересный пост от #{user.username}!")
          post.comments.create!(
            user: commenter,
            content: "Интересный пост от #{user.username}!"
          )
        end
      end

      #Добавляем лайки
      #User.where.not(id: user.id).limit(3).each do |liker|
        #unless post.likes.exists?(user: liker)
          #post.likes.create!(
            #user: liker,
          #value: [1, -1].sample
          #)
          #end
          #end

      #Добавляем лайки
      User.where.not(id: user.id).limit(3).each do |liker|
        post.likes.create!(
          user: liker,
          value: [1, -1].sample
        )
        puts "    Лайк от: #{liker.username}"
      end
    end
  end

  # Создаем подписки
  #if i > 0
  #subscribed_to = User.find(i)  # user0 подписывается на user1 и т.д.
  #unless user.subscribed_to?(subscribed_to)
  #user.subscriptions.create!(subscribed_to: subscribed_to)
  #end
  #end

  # Создаем подписки
  if i > 0
    user.subscriptions.create!(subscribed_to: User.find(i-1))
    puts "  Подписка на: #{User.find(i-1).username}"
  end
end

puts "Готово!"
puts "Создано:"
puts "- Пользователей: #{User.count}"
puts "- Постов: #{Post.count}"
puts "- Комментариев: #{Comment.count}"
puts "- Лайков: #{Like.count}"
puts "- Подписок: #{Subscription.count}"