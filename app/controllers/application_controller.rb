class ApplicationController < ActionController::Base
  before_action :login_require, except: %i[login attempt_login]

  private

  def login_require
    token = AccessToken.find_by(value: cookies[:access_token])

    if token.blank?
      flash[:notice] = 'يرجاء تسجيل الدخول'
      redirect_to(v1_login_path) and return
    end

    @current_user = token.user
    update_expire_token(cookies[:access_token])
  end

  def update_expire_token(token)
    cookies[:access_token] = {
      value: token,
      expires: 1.day.from_now
    }
  end

  def set_locale
    I18n.locale = params[:locale] || request.headers['locale'] || I18n.default_locale
  end

  def products_layout
    I18n.locale == :ar ? "application_ar" : "application"
  end
end
