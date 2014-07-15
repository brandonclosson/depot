class Product < ActiveRecord::Base
	validates_presence_of :title, :description, :image_url, :price
	validates_uniqueness_of :title
	validates :price, numericality: { greater_than_or_equal_to: 0.01 }
	validates :image_url, allow_blank: true,
		format: {
			with: %r{\.(gif|jpg|jpeg|png)\Z}i,
			message: "must be a url for a valid image file"
		}
end
