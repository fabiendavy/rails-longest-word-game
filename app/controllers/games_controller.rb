require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def word_in_grid?(grid, word)
    word.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
    return true
  end

  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end
  
  def score
    @attempt = params[:word].upcase!
    letters = params[:letters]
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt.downcase}"
    word = JSON.parse(open(url).read)
    valid_in_grid = word_in_grid?(letters.split(' '), @attempt.split(''))

    if valid_in_grid
      if word["found"]
        score = @attempt.length
        @result = "Congratulations, #{@attempt} is a valid english word! "
        @result += "Your score is #{score}"
        session[:score] += @attempt.length
        # @total_score = session[:score]
      else
        @result = "Sorry but #{@attempt} does not seem to be a valid english word"
      end
    else
      @result = "Sorry but #{@attempt} can't be built out of #{letters}"
    end
  end
end
