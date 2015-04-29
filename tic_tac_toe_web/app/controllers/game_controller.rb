class GameController < ApplicationController
  respond_to :json

  def index
    render json: {action: "game#index"}
  end

  def create
    p params
    render json: params
  end

  def new
    my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    render json: my_game.create_json_response
  end

  def play
    my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    render json: my_game.create_json_response
  end

  # def edit
  # end

  # def show
  # end

  # def update
  # end

  # def destroy
  # end

end
