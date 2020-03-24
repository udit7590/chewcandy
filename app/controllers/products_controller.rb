class ProductsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :load_user
  before_action :load_product, only: [:edit, :update, :show, :destroy]
  before_action :check_admin

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to({ action: :index }, notice: 'Product Created')
    else
      render action: 'new', status: :bad_request
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to({ action: :index }, notice: 'Product updated')
    else
      render(action: 'edit', status: :bad_request)
    end
  end

  def destroy
    if @product.destroy
      redirect_to({ action: :index }, notice: 'Product Deleted')
    else      
      render({ action: :index }, alert: 'Unable to delete product')
    end
  end

  def show
  end

  protected

    def product_params
      params.require(:product).permit(:name, :slug, :stock, :price, :discount, :image, :category, :description, :food_type, :ingredients, :min_quantity, :min_quantity_unit, :tax_inclusive)
    end

    def load_product
      @product = Product.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to({ action: :index }, alert: 'Cannot find any such product')
    end

end
