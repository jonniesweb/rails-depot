require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(
      title: 'Book title',
      description: 'xxx',
      image_url: 'img.jpg',
      price: -1)

    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0.01
    assert product.valid?

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: 'book title',
                description: 'xxx',
                price: 1,
                image_url: image_url)
  end

  test 'valid image url' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shoudn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shoudn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title: products(:ruby).title,
                          description: 'xxx',
                          price: 1,
                          image_url: 'fred.gif')

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test 'product title must be at least 10 characters' do
    product = products(:short_product_name)

    assert product.invalid?
    assert_equal ['should be at least 10 characters long'], product.errors[:title]

    ok = %w{ just_long_enough_name ruby }

    ok.each do |name|
      assert products(name).valid?, "#{name} shouldn't be invalid"
    end
  end

end
