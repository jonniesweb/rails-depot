class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    price * quantity
  end

  def pretty_name
    "#{quantity} &times; #{product.title}"
  end
end
