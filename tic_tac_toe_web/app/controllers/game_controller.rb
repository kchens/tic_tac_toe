class GameController < ApplicationController
  respond_to :json

  def index
    render json: {action: "game#index"}
  end

  def create
    human_first = params["start_human"]

    p human_first
    # VIEW = View.new
    my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    my_game.play(human_first)
    p my_game.create_json_response
    render json: my_game.create_json_response
  end

  def new
    p params
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
