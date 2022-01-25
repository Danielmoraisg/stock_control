class Food < ApplicationRecord
    validates :name, presence: true, length: {minimum: 2, maximum: 30}
    validates :quantity, presence: true
    validates :spoilage, presence: true
end
