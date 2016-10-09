module Api::V1
  class GamesController < ApplicationController
    before_action :set_game, only: [:show, :update]

    def show
      render json: { game: @game, frames: @frames }
    end

    def create
      @game = Game.new
      @frames = @game.frames

      if @game.save
        render json: { game: @game, frames:  @frames }, status: :created
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    end

    def update
      if @game.update(game_params)
        render json: { game: @game, frames:  @frames }
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    end

    private

    def set_game
      @game = Game.find(params[:id])
      @frames = @game.frames
    end

    def game_params
      params.fetch(:game, {})
    end
  end
end
