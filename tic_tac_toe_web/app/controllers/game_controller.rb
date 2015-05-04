require 'pp'

class GameController < ApplicationController
  respond_to :json

  @@my_game = nil

  def index
    render json: {action: "game#index"}
  end

  def create
    start_human = params['startHuman']

    @@my_game = Game.new(Board, HumanPlayer, ComputerPlayer)

    if start_human == 'true'
      @@my_game.play_human
    else
      @@my_game.play_computer
    end

    @@my_game.json_response
    render json: @@my_game.json_response
  end


  # used for checking json format
  def new
    p params
    @@my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
    @@my_game.set_json_response
    render json: @@my_game.json_response
  end

  def edit
    # do nothing with the game id for now
    p params
    chosen_index = params['chosenIndex'].to_i
    @@my_game.move(chosen_index)
    render json: @@my_game.json_response
  end

  # def show
  # end

  # def update
  # end

  # def destroy
  # end

end
