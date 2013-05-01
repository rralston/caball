CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp') # adding these...
  config.cache_dir = 'carrierwave' # ...two lines

  config.s3_access_key_id = ENV['AKIAJHIBHMAKIHAHLSJQ']
  config.s3_secret_access_key = ENV['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']
  config.s3_bucket = ENV['filmzu']
end