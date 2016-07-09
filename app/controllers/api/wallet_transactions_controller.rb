class Api::WalletTransactionsController < ApiController
  def index
    @transactions = WalletTransaction
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_user.id)
      .order(id: :desc)
  end

  def update
    @transaction = WalletTransaction.find(params[:id])
    @transaction.trade = params[:trade]
    if @transaction.save
      render json: { }
    else
      render json: { error: "something wrong"}
    end
  end
end
