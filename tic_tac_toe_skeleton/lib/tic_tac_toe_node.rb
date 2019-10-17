require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
      @board = board
      @next_mover_mark = next_mover_mark
      @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    #base case
    if @board.over?
      if @board.winner == evaluator || @board.winner == nil
        false
      else
        true
      end
    else
    #recursive case
      if @next_mover_mark == evaluator #self is US
        players_turn_lose = self.children.all? do |oppo_gamestate|
          oppo_gamestate.losing_node?(evaluator)
        end
      else #self is OPPO!!!
        self.children.any? do |our_gamestate|
            our_gamestate.losing_node?(evaluator)
        end
      end
    end
  end

  def winning_node?(evaluator)
    #base case
    if @board.over?
      if @board.winner != evaluator || @board.winner == nil
        return false
      else
        return true
      end
    else
    #recursive case
      players_turn_win = self.children.all? do |node|
        node.winning_node?(evaluator)
      end

      oppo_lose = self.children.all? do |oppo_gamestate|
        oppo_gamestate.children.any? do |our_gamestate|
          our_gamestate.winning_node?(evaluator)
        end
      end

      players_turn_win || oppo_lose
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
      children_array = []
      (0..2).each do |i|
        (0..2).each do |j|
          if @board.empty?([i,j])
              new_board = @board.dup
              new_board[[i,j]] = @next_mover_mark
              @next_mover_mark == :x ? new_mover_mark = :o : new_mover_mark = :x
              new_game_state = TicTacToeNode.new(new_board, new_mover_mark, [i,j])
              children_array << new_game_state
          end
        end
      end
      children_array
  end
end
