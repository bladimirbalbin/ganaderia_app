#!/usr/bin/env ruby

# Script para verificar usuario ID=4
require_relative 'config/environment'

begin
  user = User.find(4)
  puts "=== DATOS DEL USUARIO ID=4 ==="
  puts "Email: #{user.email}"
  puts "Empresa: #{user.company&.name}"
  puts "Rol: #{user.role&.name}"
  puts "Es proveedor: #{user.provider?}"
  puts "Puede gestionar usuarios: #{user.can?(:manage_users)}"
  puts "Empresa puede gestionar usuarios: #{user.company&.can_manage_users?}"
  puts "Empresa membresía activa: #{user.company&.membership_active?}"
  puts "Empresa estado suscripción: #{user.company&.subscription_status}"
  
  puts "\n=== PERMISOS DEL ROL ==="
  user.role.permissions.each do |permission|
    puts "- #{permission.name}: #{permission.description}"
  end
  
  puts "\n=== VERIFICACIÓN DE FILTROS ==="
  puts "authorize_manage_users!: #{user.can?(:manage_users)}"
  puts "check_subscription: #{user.company&.can_manage_users?}"
  puts "ensure_company_assigned!: #{user.company.present?}"
  
rescue => e
  puts "Error: #{e.message}"
end 