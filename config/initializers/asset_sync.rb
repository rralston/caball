AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.fog_directory = 'filmzu'
  config.aws_access_key_id = 'AKIAJHIBHMAKIHAHLSJQ'
  config.aws_secret_access_key = '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'

  # Don't delete files from the store
  # config.existing_remote_files = 'keep'
  #
  # Increase upload performance by configuring your region
  # config.fog_region = 'eu-west-1'
  #
  # Automatically replace files with their equivalent gzip compressed version
  # config.gzip_compression = true
  #
  # Use the Rails generated 'manifest.yml' file to produce the list of files to
  # upload instead of searching the assets directory.
  # config.manifest = true
  #
  # Fail silently.  Useful for environments such as Heroku
  # config.fail_silently = true
end