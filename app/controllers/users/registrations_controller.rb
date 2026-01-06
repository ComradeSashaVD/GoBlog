class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :full_name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :full_name])
  end

  def update_resource(resource, params)
    # Разрешаем обновление без пароля
    #if (params[:password].blank? && params[:password_confirmation].blank?) || (params[:email]..blank?)
    #resource.update_without_password(params.except(:current_password))
    #else
    #super
    #end

    # Проверяем, меняется ли email
    email_changed = params[:email].present? && params[:email] != resource.email
    # Проверяем, меняется ли пароль
    password_changed = params[:password].present?
    if email_changed || password_changed
      # Если меняем email ИЛИ пароль - требуется текущий пароль
      super
    else
      # Если меняем только username/full_name - обновляем без пароля
      resource.update_without_password(params.except(:current_password))
    end
  end

  def after_update_path_for(resource)
    user_path(resource)
  end
end