class UpdateTicketJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Book.update_info
  end
end
