require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "price must be positive" do
    product = Product.new(
      title: 'Lorem Ipsum',
      description: 'Wibbles are fun!',
      image_url: 'lorem.jpg'
    )

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
      title: 'Lorem Ipsum',
      description: 'Wibbles are fun!',
      price: 1,
      image_url: image_url
    )
  end

  test "image url" do
    ok = %W{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
            http://a.b.c/x/y/z/fred.gif }

    bad = %W{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      product = new_product(name)
      assert product.valid?, "#{name} should be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
              description: "yyy",
              price: 1,
              image_url: "ruby.jpg"
      )

    assert product.invalid?, "#{product.title} shouldn't be valid"
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]

  end

end
