require 'test_helper'

module Api::V1
  class GamesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @game = FactoryGirl.create(:game)
    end

    should "create game" do
      expect {
        post v1_games_url
      }.must_change "Game.count"

      value(response.status).must_equal 201
    end

    should "show game" do
      get v1_game_url(id: @game.id)
      value(response).must_be :success?
    end

    should "return 404 if game does not exist" do
      assert_raises ActiveRecord::RecordNotFound do
        get v1_game_url(id: -1)
        value(response).must_be :missing
      end
    end

    should "update game" do
      patch v1_game_url(id: @game.id), params: { throw: 0 }
      value(response.status).must_equal 200
    end
  end
end
