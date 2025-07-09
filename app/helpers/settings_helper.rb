module SettingsHelper
  def format_date(date)
    date.strftime("%d/%m/%Y") if date
  end

  def format_datetime(datetime)
    datetime.strftime("%d/%m/%Y %H:%M") if datetime
  end

  def membership_status_badge(company)
    if company.membership_active?
      content_tag :span, "Activa", class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800"
    else
      content_tag :span, "Inactiva", class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800"
    end
  end

  def role_badge(user)
    if user.role&.name == "Admin"
      content_tag :span, user.role.name, class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800"
    else
      content_tag :span, user.role&.name || "Sin rol", class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800"
    end
  end

  def user_avatar(user)
    content_tag :div, class: "h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center" do
      content_tag :span, user.email.first.upcase, class: "text-sm font-medium text-gray-700"
    end
  end

  def percentage_change(current, previous)
    return 0 if previous.zero?
    ((current - previous).to_f / previous * 100).round(1)
  end

  def safe_company_name(user)
    user.company&.name || "Sin empresa"
  end

  def safe_role_name(user)
    user.role&.name || "Sin rol"
  end

  def is_admin_user?(user)
    user.role&.name == "Admin"
  end
end
