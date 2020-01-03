class Tweet < ApplicationRecord
  belongs_to :user

  validates :tweet, presence: true, length: {minimum: 10, maximum: 150}
end
