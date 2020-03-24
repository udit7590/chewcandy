class RefundsController < ApplicationController
  layout :refunds_layout
  include UserInformation

  before_action :authenticate_user!
  before_action :check_admin
  before_action :verify_actions_for_filter, only: :filter
  before_action :load_refund_details, only: [:show, :complete]
  before_action :make_sure_refund_pending, only: :complete

  def index
    @refunds = Refund.active.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def complete
    if @refund.process
      redirect_to({ action: :index }, notice: "Refund processed ##{ @refund.id }")
    else
      redirect_to({ action: :show }, alert: 'Unable to process the refund')
    end
  end

  def filter
    @refunds = Refund.send(params[:by]).order(created_at: :desc).page(params[:page])
    render :index
  end

  protected

    def verify_actions_for_filter
      valid_filters = [:active, :inactive, :unscoped]
      unless valid_filters.include?(params[:by].to_sym)
        redirect_to refunds_path, alert: 'Invalid Filter'
      end
    end

    def refunds_layout
      admin_actions = ['index', 'show', 'filter']
      (@user.admin? && admin_actions.include?(action_name.to_s)) ? 'admin' : 'user'
    end

    def load_refund_details
      @refund = Refund.find_by(id: params[:id])
      unless @refund.present?
        redirect_to({ action: :index }, alert: 'No such refund id found')
      end
    end

    def make_sure_refund_pending
      if @refund.complete?
        redirect_to({ action: :show }, alert: 'This refund has already been processed')
      end
    end

end
