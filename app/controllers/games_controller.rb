require 'net/http'
require 'uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    @answer = params[:answer]

    if valid_word?(@answer)
      @message = "Congratulations! #{@answer} is a valid English word!"
    elsif @answer.chars.all? { |letter| @answer.count(letter) <= params[:letters].count(letter) }
      @message = "Sorry but #{@answer} can't be built out of #{@letters}"
    else
      @message = "Sorry but #{@answer} does not seem to be a valid English word..."
    end
  end

private

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    result['found']
  end
end
