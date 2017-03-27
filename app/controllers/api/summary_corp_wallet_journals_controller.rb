class Api::SummaryCorpWalletJournalsController < ApiController
  def index
    @summary_journals = CorpWalletJournal.summary(params[:from_i_date],
                                                  params[:to_i_date],
                                                  params[:corporation_id],
                                                  params[:corp_wallet_division_id])
  end
end
