# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Crear permisos
permissions_data = [
  { name: 'all', description: 'Todos los permisos' },
  { name: 'manage_companies', description: 'Gestionar empresas' },
  { name: 'manage_plans', description: 'Gestionar planes de membresía' },
  { name: 'manage_users', description: 'Gestionar usuarios' },
  { name: 'view_reports', description: 'Ver reportes' },
  { name: 'manage_animals', description: 'Gestionar animales' },
  { name: 'view_own_data', description: 'Ver datos propios' }
]

permissions_data.each do |perm_data|
  Permission.find_or_create_by(name: perm_data[:name]) do |permission|
    permission.description = perm_data[:description]
  end
end

# Crear roles
admin_role = Role.find_or_create_by(name: 'admin') do |role|
  role.description = 'Administrador del sistema'
end
admin_role.permissions = Permission.all

provider_role = Role.find_or_create_by(name: 'provider') do |role|
  role.description = 'Proveedor de servicios'
end
provider_role.permissions = Permission.where(name: ['manage_companies', 'manage_plans', 'manage_users', 'view_reports'])

veterinario_role = Role.find_or_create_by(name: 'veterinario') do |role|
  role.description = 'Veterinario'
end
veterinario_role.permissions = Permission.where(name: ['manage_animals', 'view_reports'])

customer_role = Role.find_or_create_by(name: 'customer') do |role|
  role.description = 'Cliente'
end
customer_role.permissions = Permission.where(name: ['view_own_data'])

# Crear usuario administrador
admin_user = User.find_or_create_by(email: 'admin@ganaderia.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = admin_role
end

# Crear usuario proveedor
provider_user = User.find_or_create_by(email: 'provider@ganaderia.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = provider_role
end

# Crear empresa proveedora
provider_company = Company.find_or_create_by(name: 'Ganadería Pro S.A.') do |company|
  company.is_provider = true
  company.subscription_status = 'active'
  company.active_until = 1.year.from_now
end

provider_user.update(company: provider_company)

# Crear planes de membresía
basic_plan = MembershipPlan.find_or_create_by(name: 'Básico') do |plan|
  plan.description = 'Plan básico para pequeñas ganaderías'
  plan.price = 29.99
  plan.users_limit = 50
  plan.duration_in_days = 30
  plan.active = true
end

premium_plan = MembershipPlan.find_or_create_by(name: 'Premium') do |plan|
  plan.description = 'Plan premium para ganaderías medianas'
  plan.price = 59.99
  plan.users_limit = 200
  plan.duration_in_days = 90
  plan.active = true
end

enterprise_plan = MembershipPlan.find_or_create_by(name: 'Empresarial') do |plan|
  plan.description = 'Plan empresarial para grandes ganaderías'
  plan.price = 99.99
  plan.users_limit = 1000
  plan.duration_in_days = 365
  plan.active = true
end

# Crear empresa cliente
customer_company = Company.find_or_create_by(name: 'Hacienda El Paraíso') do |company|
  company.is_provider = false
  company.membership_plan = premium_plan
  company.users_limit = premium_plan.users_limit
  company.subscription_status = 'active'
  company.active_until = 6.months.from_now
  company.contact_email = 'info@haciendaelparaiso.com'
end

puts "Empresa cliente creada: #{customer_company.id} - #{customer_company.name}"

# Crear usuario cliente
customer_user = User.find_or_create_by(email: 'cliente@haciendaelparaiso.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = customer_role
  user.company = customer_company
end

puts "Usuario cliente creado: #{customer_user.id} - #{customer_user.email}"
puts "Usuario tiene empresa: #{customer_user.company&.id}"

# Crear datos del cliente (temporalmente comentado)
# customer_data = Customer.create!(
#   company: customer_company,
#   first_name: 'Juan Carlos',
#   last_name: 'González',
#   address1: 'Vereda La Esperanza, Municipio de San José',
#   mobile_phone1: '+573007654321',
#   document_type: 'cc',
#   document_number = '12345678',
#   customer_type: 'person'
# )

# Asegurar que el customer tenga la empresa asignada
# if customer_data.company.nil?
#   customer_data.update!(company: customer_company)
# end

# Crear animales de prueba
puts "Creando animales para empresa: #{customer_company.id}"
animals_data = [
  {
    name: 'Rosita',
    breed: 'Holstein',
    animal_type: 'bovine',
    birth_date: 3.years.ago,
    weight: 550.0,
    gender: 'female',
    ear_tag: 'HOL001',
    status: 'active'
  },
  {
    name: 'Toro Bravo',
    breed: 'Angus',
    animal_type: 'bovine',
    birth_date: 4.years.ago,
    weight: 850.0,
    gender: 'male',
    ear_tag: 'ANG001',
    status: 'active'
  },
  {
    name: 'Luna',
    breed: 'Jersey',
    animal_type: 'bovine',
    birth_date: 2.years.ago,
    weight: 420.0,
    gender: 'female',
    ear_tag: 'JER001',
    status: 'active'
  },
  {
    name: 'Max',
    breed: 'Brahman',
    animal_type: 'bovine',
    birth_date: 5.years.ago,
    weight: 750.0,
    gender: 'male',
    ear_tag: 'BRA001',
    status: 'active'
  },
  {
    name: 'Estrella',
    breed: 'Holstein',
    animal_type: 'bovine',
    birth_date: 4.years.ago,
    weight: 580.0,
    gender: 'female',
    ear_tag: 'HOL002',
    status: 'active'
  },
  {
    name: 'Relámpago',
    breed: 'Quarter Horse',
    animal_type: 'equine',
    birth_date: 6.years.ago,
    weight: 450.0,
    gender: 'male',
    ear_tag: 'EQ001',
    status: 'active'
  },
  {
    name: 'Bella',
    breed: 'Arabian',
    animal_type: 'equine',
    birth_date: 4.years.ago,
    weight: 380.0,
    gender: 'female',
    ear_tag: 'EQ002',
    status: 'active'
  },
  {
    name: 'Trueno',
    breed: 'Appaloosa',
    animal_type: 'equine',
    birth_date: 3.years.ago,
    weight: 420.0,
    gender: 'male',
    ear_tag: 'EQ003',
    status: 'active'
  }
]

animals_data.each do |animal_data|
  animal = Animal.create!(
    company: customer_company,
    name: animal_data[:name],
    breed: animal_data[:breed],
    animal_type: animal_data[:animal_type],
    birth_date: animal_data[:birth_date],
    weight: animal_data[:weight],
    gender: animal_data[:gender],
    ear_tag: animal_data[:ear_tag],
    status: animal_data[:status]
  )

  # Crear eventos para cada animal
  if animal.gender == 'female' && animal.bovine?
    # Inseminaciones solo para bovinos hembras
    insemination = Insemination.find_or_create_by(animal: animal, insemination_date: 2.months.ago) do |ins|
      ins.bull_name = 'Toro Bravo'
      ins.technician = 'Dr. Carlos Mendoza'
      ins.notes = 'Inseminación artificial exitosa'
      ins.company = customer_company
    end

    # Palpaciones solo para bovinos hembras
    palpation = Palpation.find_or_create_by(animal: animal, palpation_date: 1.month.ago) do |pal|
      pal.result = 'pregnant'
      pal.veterinarian = 'Dr. Carlos Mendoza'
      pal.notes = 'Palpación positiva, aproximadamente 2 meses de gestación'
      pal.company = customer_company
    end

    # Producción láctea solo para bovinos
    7.times do |i|
      MilkProduction.find_or_create_by(animal: animal, production_date: i.days.ago, period: 'total') do |mp|
        mp.quantity = rand(15..25)
        mp.notes = "Producción del día #{i.days.ago.strftime('%d/%m/%Y')}"
        mp.company = customer_company
      end
    end
  end

  # Registros de peso para todos los animales
  3.times do |i|
    WeightRecord.find_or_create_by(animal: animal, weight_date: (i * 30).days.ago) do |wr|
      wr.weight = animal_data[:weight] + rand(-10..20)
      wr.notes = "Control de peso rutinario"
      wr.company = customer_company
    end
  end

  # Eventos generales para todos los animales
  AnimalEvent.find_or_create_by(animal: animal, event_type: 'health_check', event_date: 1.week.ago) do |event|
    event.description = 'Chequeo de salud rutinario'
    event.user = customer_user
    event.company = customer_company
  end

  # Crear registros médicos para algunos animales
  if rand < 0.7 # 70% de probabilidad de tener historial médico
    MedicalRecord.find_or_create_by(animal: animal, date: 2.weeks.ago) do |mr|
      mr.diagnosis = 'Chequeo rutinario de salud'
      mr.treatment = 'Vacunación anual'
      mr.veterinarian = 'Dr. Carlos Mendoza'
      mr.notes = 'Animal en buen estado de salud'
    end
  end
end

puts "Seeds completados exitosamente!"
puts "Usuarios creados:"
puts "- Admin: admin@ganaderia.com / password123"
puts "- Proveedor: provider@ganaderia.com / password123"
puts "- Cliente: cliente@haciendaelparaiso.com / password123"
puts "Animales creados: #{Animal.count}"
puts "Eventos creados: #{AnimalEvent.count + Insemination.count + Palpation.count + MilkProduction.count + WeightRecord.count}"
