class User < ActiveRecord::Base
  include GinaAuthentication::UserModel

  has_many :exports
end
