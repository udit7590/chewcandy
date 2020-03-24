class DiscountsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :load_user
  before_action :check_admin
  before_action :load_discount, only: [:show, :edit, :update, :destroy]
  before_action :build_discount, only: :create
  before_action :set_created_by, only: [:create]
  before_action :set_updated_by, only: [:update, :destroy]

  def index
    @discounts = Discount.all
  end

  def new
    @discount = Discount.new
  end

  def create
    if @discount.save
      redirect_to({ action: :index }, notice: 'Discount Created')
    else
      render action: 'new', status: :bad_request
    end
  end

  def edit
  end

  def update
    if @discount.update(discount_params)
      redirect_to({ action: :index }, notice: 'Discount updated')
    else
      render(action: 'new', status: :bad_request)
    end
  end

  def show
  end

  def destroy
    if @discount.destroy
      redirect_to({ action: :index }, notice: 'Discount Deleted')
    else      
      render({ action: :index }, alert: 'Unable to delete discount')
    end
  end

  private

    def load_discount
      @discount = Discount.find_by(id: params[:id])
      unless @discount
        redirect_to({ action: :index }, alert: 'Cannot find any such discount')
      end
    end

    def discount_params
      params.require(:discount).permit(:code, :amount, :unit, :max_amount, :email, :user_id, criteria_ids: [])
    end

    def build_discount
      @discount = Discount.new(discount_params)
    end

    def set_created_by
      @discount.created_by = @user.id
    end

    def set_updated_by
      @discount.updated_by = @user.id
    end
end
