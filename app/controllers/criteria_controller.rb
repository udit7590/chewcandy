class CriteriaController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :load_user
  before_action :check_admin
  before_action :load_criterium, only: [:show, :edit, :update, :destroy]
  before_action :build_criterium, only: :create
  before_action :point_to_apt_object, only: [:edit, :show, :destroy]

  def index
    @criteria = Criterium.all
  end

  def new
    @criterium = Criterium.new
  end

  def create
    if @criterium.save
      redirect_to({ action: :edit }, notice: 'Criterium created')
    else
      render action: 'new', status: :bad_request
    end
  end

  def edit
  end

  def update
    if @criterium.update(criterium_params)
      redirect_to({ action: :edit }, notice: 'Criterium updated')
    else
      render(action: 'new', status: :bad_request)
    end
  end

  def show
  end

  def destroy
    if @criterium.destroy
      redirect_to({ action: :index }, notice: 'Criterium Deleted')
    else      
      render({ action: :index }, alert: 'Unable to delete criterium')
    end
  end

  private

    def load_criterium
      @criterium = Criterium.find_by(id: params[:id])
      unless @criterium
        redirect_to({ action: :index }, alert: 'Cannot find any such criterium')
      end
    end

    def criterium_params
      params.require(:criterium).permit(:name, :one_time, :valid_from, :valid_till, :actable_type)
    end

    def build_criterium
      @criterium = Criterium.new(criterium_params)
    end

    def point_to_apt_object
      @criterium_type = @criterium.becomes(@criterium.actable_type.constantize)
    end
end
