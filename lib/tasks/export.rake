namespace :export do  
  desc "Extract source data out to a json file"
  task :db => :environment do
    name = ENV['model']
    raise "Please specify a model using 'model=ModelName'" unless name.present?
    klass = name.constantize
    
    File.open(Rails.root.join("db/#{name.underscore}.json"), 'w') do |fp|
      fp << klass.all.to_json
    end
  end
end