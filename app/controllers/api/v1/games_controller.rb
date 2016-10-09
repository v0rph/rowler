module Api::V1
  class GamesController < ApplicationController
    before_action :set_game, only: [:show, :update]

    def show
      render json: @game.attributes_for_show
    end

    def create
      game = Game.new
      frames = game.frames

      if game.save
        render json: game.attributes_for_show, status: :created
      else
        render json: game.errors, status: :unprocessable_entity
      end
    end

    def update
      if @game.throw_ball(params[:throw].to_i)
        render json: @game.attributes_for_show #{ game: @game, frames:  @frames }
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    end

    private

    def set_game
      @game = Game.find(params[:id])
      @frames = @game.frames
    end
  end
end
