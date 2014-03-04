APP = YAML.load_file("#{Rails.root.to_s}/config/app.yml")[Rails.env]

Balanced.configure(APP["balanced_secret_key"])