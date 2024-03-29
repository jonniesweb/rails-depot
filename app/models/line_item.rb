class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart

  def total_price
    price * quantity
  end

  def pretty_name
    "#{quantity} &times; #{product.title}"
  end
end
