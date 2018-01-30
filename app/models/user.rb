class User < ApplicationRecord
  include GinaAuthentication::UserModel

  has_many :exports, dependent: :destroy
  has_many :site_exports, dependent: :destroy
end
