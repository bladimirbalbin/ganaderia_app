class AddManageUsersPermissionToRoles < ActiveRecord::Migration[7.1]
  def up
    # Crear el permiso manage_users si no existe
    manage_users_permission = Permission.find_or_create_by(name: 'manage_users') do |permission|
      permission.description = 'Gestionar usuarios'
    end

    # Agregar el permiso a los roles que lo necesitan
    admin_role = Role.find_by(name: 'admin')
    if admin_role
      admin_role.permissions << manage_users_permission unless admin_role.permissions.include?(manage_users_permission)
    end

    provider_role = Role.find_by(name: 'provider')
    if provider_role
      provider_role.permissions << manage_users_permission unless provider_role.permissions.include?(manage_users_permission)
    end

    # También agregar a roles con nombre 'Admin' (mayúscula)
    admin_role_capital = Role.find_by(name: 'Admin')
    if admin_role_capital
      admin_role_capital.permissions << manage_users_permission unless admin_role_capital.permissions.include?(manage_users_permission)
    end
  end

  def down
    # Remover el permiso de los roles
    manage_users_permission = Permission.find_by(name: 'manage_users')
    return unless manage_users_permission

    Role.all.each do |role|
      role.permissions.delete(manage_users_permission) if role.permissions.include?(manage_users_permission)
    end
  end
end 