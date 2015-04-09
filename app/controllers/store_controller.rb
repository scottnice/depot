class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    puts @products.inspect
  end
end
