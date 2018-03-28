require "./a-star/*"

module AStar
  extend self

  def search(start : T, goal : T, &block) forall T
    open = [] of T
    closed = [] of T
    open << start
    start.g = 0
    start.f = yield start, goal

    until open.empty?
      current = open.sort! { |a, b| a.f <=> b.f }.first
      return reconstruct_path goal if current == goal

      open.delete current
      closed << current

      current.neighbor.each do |neighbor, distance|
        next if closed.includes? neighbor
        open << neighbor unless open.includes? neighbor
        if (new_g = current.g + distance) < neighbor.g
          neighbor.parent = current
          neighbor.g = new_g
          neighbor.f = new_g + yield neighbor, goal
        end
      end
    end
    # at the end make sure to reset all nodes
    # in case someone wants to rerun the search
    open.map! &.reset
    closed.map! &.reset
    nil
  end

  def reconstruct_path(node)
    path = [] of typeof(node)
    path << node
    while node = node.parent
      path << node
    end
    path.reverse!
  end

  class Node(T)
    getter data : T
    property parent : self?
    property g : Number::Primitive = Float64::INFINITY
    property f : Number::Primitive = Float64::INFINITY
    getter neighbor = Hash(self, Number::Primitive).new

    def initialize(@data : T = nil); end

    def connect(node : self, distance : Number::Primitive)
      @neighbor[node] = distance
      node.neighbor[self] = distance
    end

    def reset
      @g = Float64::INFINITY
      @f = Float64::INFINITY
      self
    end

    def to_s(io : IO) : Nil
      io << @name
    end
  end
end
