module ApplicationHelper
  def provider?
    current_user&.company&.is_provider?
  end
end
