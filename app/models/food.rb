class Food < ApplicationRecord
    audited max_audits: 10,  only: :quantity
    validates :name, presence: true, length: {minimum: 2, maximum: 30}
    validates :quantity, presence: true
    validates :spoilage, presence: true
end
