class V1::SessionController < ApplicationController

  def login
    token = AccessToken.find_by(value: cookies[:access_token])

    if token.present?
      flash[:notice] = 'لقد تم تسجيل دخولك'
      redirect_to(root_path)
    end
  end

  def attempt_login
    if params[:name] && params[:password] && params[:country]
      user = User.find_by(username: params[:name])
      if user && user.authenticate(params[:password])
        update_expire_token(user.generate_token)
        flash[:notice] = 'لقد تم تسجيل دخولك'
        redirect_to(root_path)
      else
        flash[:notice] = 'خطأ في الاسم او كلمة المرور'
        redirect_to(v1_session_login_path)
      end
    end
  end

  def logout
    access_token = current_user.access_tokens
                               .find_by(value: cookies[:access_token])
    access_token.destroy
    cookies.delete :access_token
    flash[:notice] = 'لقد تم تسجيل خروجك'
    redirect_to(root_path)
  end
end
