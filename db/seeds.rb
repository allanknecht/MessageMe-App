# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Limpar dados existentes (opcional - descomente se quiser resetar)
# User.destroy_all
# Message.destroy_all

# Criar 6 usuários
user1 = User.create!(username: "alice", password: "password")
user2 = User.create!(username: "bob", password: "password")
user3 = User.create!(username: "charlie", password: "password")
user4 = User.create!(username: "diana", password: "password")
user5 = User.create!(username: "eve", password: "password")
user6 = User.create!(username: "frank", password: "password")

# Mensagens para Alice
Message.create!(body: "Olá pessoal! Como vocês estão?", user: user1)
Message.create!(body: "Alguém quer conversar sobre tecnologia?", user: user1)
Message.create!(body: "Acabei de descobrir esse app, muito legal!", user: user1)
Message.create!(body: "Bom dia a todos! ☀️", user: user1)

# Mensagens para Bob
Message.create!(body: "E aí galera! Tudo bem?", user: user2)
Message.create!(body: "Alguém aqui gosta de programação?", user: user2)
Message.create!(body: "Estou aprendendo Rails, alguém tem dicas?", user: user2)
Message.create!(body: "Que dia lindo hoje!", user: user2)
Message.create!(body: "Vamos fazer um projeto juntos?", user: user2)

# Mensagens para Charlie
Message.create!(body: "Oi! Primeira vez aqui.", user: user3)
Message.create!(body: "Esse chat está muito legal!", user: user3)
Message.create!(body: "Alguém quer trocar uma ideia?", user: user3)
Message.create!(body: "Boa noite pessoal! 🌙", user: user3)

# Mensagens para Diana
Message.create!(body: "Olá! Como funciona esse app?", user: user4)
Message.create!(body: "Estou adorando a interface!", user: user4)
Message.create!(body: "Alguém pode me ajudar com uma dúvida?", user: user4)
Message.create!(body: "Muito bom esse sistema de mensagens!", user: user4)
Message.create!(body: "Obrigada pela ajuda! 😊", user: user4)

# Mensagens para Eve
Message.create!(body: "Hey! Tudo certo?", user: user5)
Message.create!(body: "Que horas são aí?", user: user5)
Message.create!(body: "Vamos conversar sobre qualquer coisa!", user: user5)
Message.create!(body: "Esse é um ótimo lugar para conversar!", user: user5)

# Mensagens para Frank
Message.create!(body: "Boa tarde pessoal!", user: user6)
Message.create!(body: "Alguém aqui é desenvolvedor?", user: user6)
Message.create!(body: "Estou procurando pessoas para colaborar em projetos!", user: user6)
Message.create!(body: "Muito legal esse chat em tempo real!", user: user6)
Message.create!(body: "Vamos fazer networking aqui!", user: user6)
Message.create!(body: "Obrigado por me receberem! 👋", user: user6)

puts "Seeds criados com sucesso!"
puts "#{User.count} usuários criados"
puts "#{Message.count} mensagens criadas"
