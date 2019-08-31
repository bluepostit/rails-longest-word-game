require 'open-uri'
require 'json'

DICT_API_URL = 'https://wagon-dictionary.herokuapp.com/'

class GamesController < ApplicationController
  def new
    @letters = random_letters(10)
    @letters = 'twe'.chars
    puts @letters
  end

  def score
    puts params
    @letters = params[:letters].chars
    @word = params[:word].strip
    if !contains_letters?(@word.chars, @letters.dup)
      @error = :word_not_from_grid
    elsif !valid_word?(@word)
      @error = :word_not_valid
    end
  end

  def valid_word?(word)
    url = DICT_API_URL + word
    response = open(url).read
    json = JSON.parse(response)
    json['found']
  end

  def contains_letters?(needle, haystack)
    needle.each do |letter|
      return false unless haystack.include? letter

      haystack.delete(letter)
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
end
