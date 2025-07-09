namespace :users do
  desc "Detectar usuarios sin empresa asignada"
  task detect_orphaned: :environment do
    orphaned_users = User.where(company: nil)
    
    if orphaned_users.any?
      puts "⚠️  Se encontraron #{orphaned_users.count} usuarios sin empresa asignada:"
      orphaned_users.each do |user|
        puts "  - #{user.email} (ID: #{user.id})"
      end
    else
      puts "✅ No se encontraron usuarios sin empresa asignada."
    end
  end

  desc "Asignar empresa proveedora a usuarios sin empresa"
  task assign_provider_company: :environment do
    provider_company = Company.find_by(is_provider: true)
    
    unless provider_company
      puts "❌ No se encontró una empresa proveedora en el sistema."
      puts "   Crea una empresa con is_provider = true primero."
      exit 1
    end

    orphaned_users = User.where(company: nil)
    
    if orphaned_users.any?
      puts "🔄 Asignando #{orphaned_users.count} usuarios a la empresa proveedora..."
      
      orphaned_users.each do |user|
        user.update!(company: provider_company)
        puts "  ✅ #{user.email} asignado a #{provider_company.name}"
      end
      
      puts "✅ Proceso completado."
    else
      puts "✅ No hay usuarios sin empresa asignada."
    end
  end

  desc "Verificar integridad de datos de usuarios"
  task verify_integrity: :environment do
    puts "🔍 Verificando integridad de datos de usuarios..."
    
    # Usuarios sin empresa
    orphaned_users = User.where(company: nil)
    if orphaned_users.any?
      puts "❌ #{orphaned_users.count} usuarios sin empresa asignada"
    else
      puts "✅ Todos los usuarios tienen empresa asignada"
    end
    
    # Usuarios sin rol
    users_without_role = User.where(role: nil)
    if users_without_role.any?
      puts "❌ #{users_without_role.count} usuarios sin rol asignado"
    else
      puts "✅ Todos los usuarios tienen rol asignado"
    end
    
    # Usuarios con email duplicado
    duplicate_emails = User.group(:email).having('count(*) > 1').pluck(:email)
    if duplicate_emails.any?
      puts "❌ #{duplicate_emails.count} emails duplicados encontrados"
    else
      puts "✅ No hay emails duplicados"
    end
    
    # Verificar que exista al menos una empresa proveedora
    provider_companies = Company.where(is_provider: true)
    if provider_companies.any?
      puts "✅ Se encontraron #{provider_companies.count} empresa(s) proveedora(s)"
    else
      puts "⚠️  No se encontraron empresas proveedoras"
    end
    
    puts "✅ Verificación completada."
  end
end 