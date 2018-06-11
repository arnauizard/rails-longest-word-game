require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = ('a'..'z').to_a.sample(10)
    @starttime = Time.now
  end

  def score


    @endtime = Time.now
    @guess = params[:guess]
    @grid = params[:grid]
    @time_taken = @endtime.to_i - params[:starttime].to_i
    if included?(@guess.upcase, @grid)
      if english_word?(@guess)
      #score = compute_score(guess)
      @result = [50, "well done"]
      else
      @result = [0, "not an english word"]
      end
    else
      @result = [0, "not in the grid"]
    end
  end


  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

# def run_game(attempt, grid, start_time, end_time)
#   result = { time: end_time - start_time }

#   score_and_message = score_and_message(attempt, grid, result[:time])
#   result[:score] = score_and_message.first
#   result[:message] = score_and_message.last

#   result
# end


  def english_word?
    response = open("https://wagon-dictionary.herokuapp.com/#{@guess}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
