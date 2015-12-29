class Search < ActiveRecord::Base
  serialize :params, JSON

  def self.params_dump(data)
    JSON.dump(data.to_hash)
  end
end
