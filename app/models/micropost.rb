# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user # можно добавить counter_cache: true, при условии добавления счетчика в БД
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) } # Плохо! Влияет на все операции с моделью, для обхода теперь нужно использовать метод .unscoped
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: 'must be a valid image format' },
                      size: { less_than: 5.megabytes,
                              message: 'should be less than 5MB' }
end
