class V1::UsersController < V1::BaseController
  power :users, map: {
    [:index] => :users_index,
    [:show] => :users_show,
    [:create] => :creatable_users,
    [:update] => :updatable_users,
    [:destroy] => :destroyable_users
  }, as: :users_scope

  skip_before_action :authorize_request, only: :create

   # POST /signup
  # return authenticated token upon signup
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    data = { message: Message.account_created, auth_token: auth_token }
    render_created(data: data, message: Message.account_created)
  end

  private

    def user_params
      params.permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :avatar
      )
    end
end
