class Power
  include Consul::Power

  attr_accessor :current_user, :params

  def initialize(user, params)
    self.current_user = user
    self.params = params
  end

  power :users_index do
    User.all
  end

  power :users_show do
    User
  end

  power :creatable_users do
    User
  end

  power :updatable_users do
    User
  end

  power :destroyable_users do
    User
  end

  power :dashboard do
    true # not a scope, but a boolean power. This is useful to control access to stuff that doesn't live in the database.
  end
end
