class Product < ActiveRecord::Base
  validates :title, :description, :price, :image_url,:stock_qnty, :presence =>true
  validates :title, :uniqueness => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.00}
  validates :stock_qnty, :numericality => {:greater_than_or_equal_to => 1}
  validates :image_url, :format =>{
    :with => %r{\.(gif|jpg|png)$}i,
    :message => 'must be a URL for GIF, JPG, or PNG image.'
  }
end
