require 'open-uri'
require 'json'

DICT_API_URL = 'https://wagon-dictionary.herokuapp.com/'

class GamesController < ApplicationController

  def new
    set_cache_headers
    @letters = random_letters(10)
  end

  def score
    @letters = params[:letters].chars
    @word    = params[:word].strip
    if !contains_letters?(@word.chars, @letters.dup)
      @error = :word_not_from_grid
    elsif !valid_word?(@word)
      @error = :word_not_valid
    end
    calculate_score(@word)
  end

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
  end

  def valid_word?(word)
    url = DICT_API_URL + word
    response = open(url).read
    json = JSON.parse(response)
    json['found']
  end

  def contains_letters?(needle, haystack)
    # binding.pry
    needle.each do |letter|
      return false unless haystack.include? letter

      # delete only the first instance of the letter
      haystack.delete_at(haystack.index(letter))
    end
    true
  end

  def random_letters(count)
    letters = []
    alphabet = 'abcdefghijklmnopqrstuvwxyz'.chars
    count.times do
      letters.push(alphabet.sample)
    end
    letters
  end

  def calculate_score(word)
    @current_score = @error.nil? ? word.length : 0
    @total_score = session[:total_score] || 0
    @total_score += @current_score
    session[:total_score] = @total_score
  end
end
