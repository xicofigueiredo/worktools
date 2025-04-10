class Newsletter < ApplicationRecord
  # has_many_attached :images

  has_rich_text :content
end
