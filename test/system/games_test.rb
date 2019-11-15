require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "visiting /new gives a new random letter grid" do
    visit new_url
    assert test: "New game"
    assert_selector 'div', class: 'letter', count: 10
  end

  test "submitting a random word gets error: Word not in grid" do
    visit new_url
    fill_in 'word', with: 'xxxxxxxxx'
    click_on 'Play'

    assert test: "Sorry, but XXXXXXXXX can't be built out of "
  end
end
