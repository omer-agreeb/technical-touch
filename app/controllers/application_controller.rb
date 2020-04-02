class ApplicationController < ActionController::Base
  before_action :set_locale
  layout :products_layout

  private

  def set_locale
    I18n.locale = params[:locale] || request.headers['locale'] || I18n.default_locale
  end

  def products_layout
    I18n.locale == :ar ? "application_ar" : "application"
  end
end
