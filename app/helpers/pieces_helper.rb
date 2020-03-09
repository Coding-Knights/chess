module PiecesHelper
    def promotable?
        return true if self.color == 1 && y_position == 7
        return true if self.color == 2 && y_position == 0
        false
    end 
end
