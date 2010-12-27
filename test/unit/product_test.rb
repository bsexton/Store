require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attribute must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    assert product.errors[:stock_qnty].any?
  end
  
  test "product price must be positive" do
    product = Product.new(:title => "Prod1",
                          :description =>"yyy",
                          :image_url => "test.jpg",
                          :stock_qnty => 1
                          )
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.0",
      product.errors[:price].join('; ')
      
    product.price=1
    assert product.valid?
  end
  
  test "stock must be positive" do
    product = Product.new(:title => "Prod1",
                          :description =>"yyy",
                          :image_url => "test.jpg",
                          :price => 1
                          )
    product.stock_qnty = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 1",
      product.errors[:stock_qnty].join('; ')
      
    product.stock_qnty=1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(:title  => "Title",
                :description => "yyy",
                :price => 1,
                :stock_qnty => 1,
                :image_url => image_url)
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.jpg FRED.Jpg
        htt://a.b.c/x/y/z/fred.gif}
    bad = %w{ fred.abc fred.jpg/more fred.gif.more}
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "{name shouldn't be valid}"
    end    
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(:title       => products(:ruby).title,
                          :description => "yyy",
                          :price       => 1,
                          :stock_qnty  => 1,
                          :image_url   => "fred.gif")
                  
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')              
  end
  
end
