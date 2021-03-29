class Storage < ApplicationRecord
  include FileUploader[:file]
end
