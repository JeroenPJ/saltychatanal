class PagesController < ApplicationController
  def home
  end

  def result
    input = params[:input]
    options = {}
    options[:relative] = params[:relative] == "true"
    options[:as_word] = params[:as_word] == "true"

    result = User.count_messages_with(input, options)

    render json: result
  end
end
