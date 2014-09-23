Sidekiq.configure_server do |config|
  config.redis = { url: "redis://192.168.222.227:6379/12", namespace: "development" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://192.168.222.227:6379/12", namespace: "development" }
end
