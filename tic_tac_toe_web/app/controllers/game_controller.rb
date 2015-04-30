class GameController < ApplicationController
  respond_to :json

  def index
    render json: {action: "game#index"}
  end

  def create
    p "-----------------"
    p params
    p "-----------------"
    start_human = params['startHuman']

    p start_human
    # VIEW = View.new
    my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    my_game.play(start_human)
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
