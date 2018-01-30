class Membership < ApplicationRecord
  include GinaAuthentication::MembershipModel
end
