class Admin::DashboardController < ApplicationController
  def show
    @num_products = Product.count()
    @num_categories = Category.count()
  end
end
