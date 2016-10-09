require 'test_helper'

module Api::V1
  class GamesTest < ActionDispatch::IntegrationTest
    should 'create and return new game' do
      post v1_games_url

      assert_equal '{"game":{"id":1,"finished":false,"current_frame":1,"score":0,"frames":[{"number":1,"first_throw":-1,"second_throw":-1,"points":0},{"number":2,"first_throw":-1,"second_throw":-1,"points":0},{"number":3,"first_throw":-1,"second_throw":-1,"points":0},{"number":4,"first_throw":-1,"second_throw":-1,"points":0},{"number":5,"first_throw":-1,"second_throw":-1,"points":0},{"number":6,"first_throw":-1,"second_throw":-1,"points":0},{"number":7,"first_throw":-1,"second_throw":-1,"points":0},{"number":8,"first_throw":-1,"second_throw":-1,"points":0},{"number":9,"first_throw":-1,"second_throw":-1,"points":0},{"number":10,"first_throw":-1,"second_throw":-1,"points":0},{"number":11,"first_throw":-1,"second_throw":-1,"points":0},{"number":12,"first_throw":-1,"second_throw":-1,"points":0}]}}', response.body
    end

    context 'update game' do
      setup do
        @game = FactoryGirl.create :game
      end

      should "return error message on invalid play" do
        put v1_game_url(id: @game.id), params: { throw: 20 }

        assert_equal 422, response.status
        assert_equal "Invalid Play.", JSON.parse(response.body)["base"][0]["message"]
      end

      should "return error message when posting to a finished game" do
        finished_game = FactoryGirl.create :game
        finished_game.finished = true
        finished_game.save

        put v1_game_url(id: finished_game.id), params: { throw: 5 }

        assert_equal 422, response.status
        assert_equal "This game has ended.", JSON.parse(response.body)["base"][0]["message"]
      end

      should "move to next frame if first throw knocks 10 pins" do
          put v1_game_url(id: @game.id), params: { throw: 10 }

          assert_equal 2, JSON.parse(response.body)["game"]["current_frame"]
      end

      should "end frame after throwing second ball" do
        put v1_game_url(id: @game.id), params: { throw: 0 }
        put v1_game_url(id: @game.id), params: { throw: 5 }

        assert_equal 2, JSON.parse(response.body)["game"]["current_frame"]
      end

      should "score normal frame by adding the number of pins knocked down plus previous frame score" do
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 1 }

        assert_equal 4, JSON.parse(response.body)["game"]["score"]
      end

      should "correctly score a perfect game" do
        12.times { put v1_game_url(id: @game.id), params: { throw: 10 } }

        assert_equal 300, JSON.parse(response.body)["game"]["score"]
      end

      should "correctly score third ball if spare is scored on 10th frame" do
        18.times { put v1_game_url(id: @game.id), params: { throw: 1 } }
        put v1_game_url(id: @game.id), params: { throw: 4 }
        put v1_game_url(id: @game.id), params: { throw: 6 }
        put v1_game_url(id: @game.id), params: { throw: 5 }

        assert_equal 33, JSON.parse(response.body)["game"]["score"]
      end

      should "correctly score game that ends on frame 10" do
        put v1_game_url(id: @game.id), params: { throw: 10 }
        10.times{ put v1_game_url(id: @game.id), params: { throw: 3 } }
        put v1_game_url(id: @game.id), params: { throw: 3 }
        put v1_game_url(id: @game.id), params: { throw: 7 }
        6.times{ put v1_game_url(id: @game.id), params: { throw: 3 }  }

        assert_equal 77, JSON.parse(response.body)["game"]["score"]
      end

      should "score strike frame by adding 10 to previous score plus score of next 2 throws" do
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 10 }
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 1 }

        assert_equal 16, JSON.parse(response.body)["game"]["score"]
      end

      should "score spare frame by adding 10 to previous score plus the score of the next throw" do
        put v1_game_url(id: @game.id), params: { throw: 5 }
        put v1_game_url(id: @game.id), params: { throw: 5 }
        put v1_game_url(id: @game.id), params: { throw: 1 }
        put v1_game_url(id: @game.id), params: { throw: 1 }

        assert_equal 13, JSON.parse(response.body)["game"]["score"]
      end
    end
  end
end
