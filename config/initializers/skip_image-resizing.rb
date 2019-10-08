if Rails.env.test?
  CarrierWave.configure { |config| config.enable_processing = false }
end
