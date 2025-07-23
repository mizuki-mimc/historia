require 'fileutils'

RSpec.configure do |config|
  config.after(:each) do |example|
    if example.metadata[:type] == :system
      FileUtils.rm_rf(Rails.root.join("tmp", "storage")) if Dir.exist?(Rails.root.join("tmp", "storage"))
    end
  end

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join("tmp", "storage")) if Dir.exist?(Rails.root.join("tmp", "storage"))
  end
end
