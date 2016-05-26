class User < ActiveRecord::Base
  include GinaAuthentication::UserModel

  has_many :exports, dependent: :destroy
end
