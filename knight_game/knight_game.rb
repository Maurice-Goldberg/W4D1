require "./00_tree_node.rb"

class KnightPathFinder
    attr_reader :root_node
    def initialize(pos)
        @root_node = PolyTreeNode.new(pos)
        @board = Array.new(8) { Array.new(8) }
        @considered_positions = [pos]
    end

    def self.valid_moves(pos)
        valid_moves_arr = []
        x, y = pos[0], pos[1]

        valid_moves_arr << [x+1, y+2]
        valid_moves_arr << [x+1, y-2]
        valid_moves_arr << [x-1, y+2]
        valid_moves_arr << [x-1, y-2]
        valid_moves_arr << [x+2, y+1]
        valid_moves_arr << [x+2, y-1]
        valid_moves_arr << [x-2, y+1]
        valid_moves_arr << [x-2, y-1]

        valid_moves_arr.select do |pos|
            (pos[0] < 8 && pos[0] >= 0) &&
            (pos[1] < 8 && pos[1] >= 0)
        end
    end

    def new_move_positions(pos)
        new_moves_arr = KnightPathFinder.valid_moves(pos).reject do |position|
            @considered_positions.include?(position)
        end
        @considered_positions += new_moves_arr
        new_moves_arr
    end

    def build_move_tree
        queue = [@root_node]
        until queue.empty?
            node = queue.shift
            new_move_positions(node.value).each do |position|
                child = PolyTreeNode.new(position)
                node.add_child(child)
                queue.push(child)
            end
        end  
    end

    def find_path(end_pos)
        trace_path_back(@root_node.bfs(end_pos))
    end

    def trace_path_back(node)
        path = [node.value]
        dad = node.parent
        until dad == @root_node
            path.unshift(dad.value)
            dad = dad.parent
        end
        path.unshift(@root_node.value)
        path
    end
end

if __FILE__ == $PROGRAM_NAME
    kpf = KnightPathFinder.new([0,0])
end