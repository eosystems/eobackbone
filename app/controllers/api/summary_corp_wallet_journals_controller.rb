class Api::SummaryCorpWalletJournalsController < ApiController
  def index
    @summary_journals = CorpWalletJournal.summary(params[:from_i_date],
                                                  params[:to_i_date],
                                                  params[:corporation_id],
                                                  params[:division_id])
    render json: @summary_journals
  end
end
