require 'rest_client'
class Api::V1::ServertimeController < ApiController
  def get_servertime
    uri = params[:target]
    @result = {
      target: uri,
      result: RestClient.get(uri).headers[:date]
    }
    render json: @result
  end
end
