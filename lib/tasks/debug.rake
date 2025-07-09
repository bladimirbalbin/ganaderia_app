namespace :debug do
  desc "Verificar configuración de usuario proveedor"
  task check_provider_user: :environment do
    puts "🔍 Verificando configuración de usuarios proveedores..."
    
    # Buscar empresas proveedoras
    provider_companies = Company.where(is_provider: true)
    puts "\n📋 Empresas proveedoras encontradas:"
    if provider_companies.any?
      provider_companies.each do |company|
        puts "  - #{company.name} (ID: #{company.id})"
        puts "    is_provider: #{company.is_provider?}"
        puts "    membership_active: #{company.membership_active?}"
        puts "    can_manage_users: #{company.can_manage_users?}"
        
        # Mostrar usuarios de esta empresa
        company.users.each do |user|
          puts "    👤 Usuario: #{user.email} (ID: #{user.id})"
          puts "      admin?: #{user.admin?}"
          puts "      provider?: #{user.provider?}"
          puts "      role: #{user.role&.name}"
          puts "      company: #{user.company&.name}"
        end
      end
    else
      puts "  ❌ No se encontraron empresas proveedoras"
    end
    
    # Buscar usuarios administradores
    admin_users = User.joins(:role).where(roles: { name: 'Admin' })
    puts "\n👑 Usuarios administradores encontrados:"
    if admin_users.any?
      admin_users.each do |user|
        puts "  - #{user.email} (ID: #{user.id})"
        puts "    admin?: #{user.admin?}"
        puts "    provider?: #{user.provider?}"
        puts "    company: #{user.company&.name}"
        puts "    company_is_provider: #{user.company&.is_provider?}"
      end
    else
      puts "  ❌ No se encontraron usuarios administradores"
    end
    
    # Verificar permisos
    puts "\n🔐 Verificando permisos:"
    admin_users.each do |user|
      puts "  Usuario: #{user.email}"
      puts "    Puede acceder a settings?: #{user.admin? || user.provider?}"
      puts "    Puede gestionar usuarios?: #{user.can?(:manage_users)}"
      puts "    Puede gestionar empresas?: #{user.provider?}"
    end
  end

  desc "Crear empresa proveedora de prueba"
  task create_provider_company: :environment do
    puts "🏗️  Creando empresa proveedora de prueba..."
    
    # Verificar si ya existe una empresa proveedora
    existing_provider = Company.find_by(is_provider: true)
    if existing_provider
      puts "⚠️  Ya existe una empresa proveedora: #{existing_provider.name}"
      return
    end
    
    # Crear empresa proveedora
    provider_company = Company.create!(
      name: "Empresa Proveedora del Sistema",
      contact_email: "admin@proveedor.com",
      is_provider: true,
      active: true
    )
    
    puts "✅ Empresa proveedora creada: #{provider_company.name}"
    
    # Verificar si existe el rol Admin
    admin_role = Role.find_by(name: 'Admin')
    unless admin_role
      puts "⚠️  No existe el rol Admin. Creándolo..."
      admin_role = Role.create!(name: 'Admin', description: 'Administrador del sistema')
    end
    
    # Crear usuario administrador para la empresa proveedora
    admin_user = User.create!(
      email: "admin@proveedor.com",
      password: "password123",
      password_confirmation: "password123",
      company: provider_company,
      role: admin_role
    )
    
    puts "✅ Usuario administrador creado: #{admin_user.email}"
    puts "   Contraseña: password123"
    puts "   Puede acceder a settings?: #{admin_user.admin? || admin_user.provider?}"
  end
end 