class GameController < ApplicationController
  respond_to :json

  def index
    render json: {action: "game#index"}
  end

  def create
    start_human = params['startHuman']

    my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    my_game.play(start_human)

    p my_game.get_json_response
    render json: my_game.get_json_response
  end


  # used for checking json format
  def new
    p params
    my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    my_game.set_json_response("false")
    render json: my_game.get_json_response
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
