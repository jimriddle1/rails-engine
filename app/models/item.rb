class Item < ApplicationRecord
  # validates :name, presence: true
  # validates :description, presence: true
  # validates :unit_price, presence: true
  # validates :merchant_id, presence: true
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  
  def delete_item_invoices
    if invoices.count > 0
      invoices.map do |invoice|
        invoice.destroy
      end
    end
  end

end
