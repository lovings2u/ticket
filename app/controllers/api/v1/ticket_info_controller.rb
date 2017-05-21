class Api::V1::TicketInfoController < ApiController
  def all_ticket_info
    count = Book.all.count
    interpark = Book.where(source_site: 1)
    melon = Book.where(source_site: 2)
    auction = Book.where(source_site: 3)
    yes24 = Book.where(source_site: 4)
    @result = {
      result_count: count,
      interpark_ticket: interpark,
      melon_ticket: melon,
      auction_ticket: auction,
      yes24_ticket: yes24
    }
    render json: @result
  end
  def each_ticket_info
    tickets = Book.where(source_site: params[:source])
    get_result(tickets)
    render json: @result
  end

  def tickets
    tickets = Book.all.order("open_date DESC").offset(params[:page_no]).limit(params[:per_page])
    get_result(tickets)
    render json: @result
  end
  def search_ticket
    @result = Book.find(params[:ticket_id])
    render json: @result
  end
  private
  def get_result(tickets)
    @result = {
      result_count: tickets.count,
      result: tickets
    }
  end


end
