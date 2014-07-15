require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "Abcde", description: "B", image_url: "c.jpg")
    product.price = -1
    assert product.invalid?
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    product.price = 1
    product.valid?
  end

  def new_product_supplying_image_url(image_url)
    Product.new(title: "Some Book",
                description: "A little description",
                image_url: image_url,
                price: 14141.00)
  end

  test "valid image url" do
    ok = %w{ brandon.gif BRANDON.GIF pic.jpg PIC.Jpg http://somesite.com/path/to/image.jpeg ping.png }
    bad = %w{ brandon.doc brandon.jpg/more }

    ok.each do |url|
      assert new_product_supplying_image_url(url).valid?, "#{url} should be valid"
    end

    bad.each do |url|
      assert new_product_supplying_image_url(url).invalid?, "#{url} should be invalid"
    end
  end

  test "product is not valid without unique title" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "selfie.jpg")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test "product title must be at least five characters long" do
    product = Product.new(title: "abc", description: "blah", price: 10, image_url: "selfie.png")
    assert product.invalid?
    product.title = "abcde"
    assert product.valid?
  end
end
