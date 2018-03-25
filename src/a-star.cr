require "./a-star/*"

class AStar
  def initialize(&@heuristic : Node, Node -> Number::Primitive); end

  def search(start : Node, goal : Node) : Array(Node)?
    open = [] of Node
    closed = [] of Node
    open << start
    start.g = 0
    start.f = @heuristic.call start, goal

    until open.empty?
      current = open.sort!.first
      return reconstruct_path goal if current == goal

      open.delete current
      closed << current

      current.neighbor.each do |neighbor, distance|
        next if closed.includes? neighbor
        open << neighbor unless open.includes? neighbor
        unless (new_g = current.g + distance) >= neighbor.g
          neighbor.parent = current
          neighbor.g = new_g
          neighbor.f = new_g + @heuristic.call neighbor, goal
        end
      end
    end
    # at the end make sure to reset all nodes
    # in case someone wants to rerun the search
    open.map! &.reset
    closed.map! &.reset
    nil
  end

  private def reconstruct_path(node : Node)
    path = [] of Node
    path << node
    while node = node.parent
      path << node
    end
    path.reverse!
  end

  class Node
    include Comparable(self)

    getter name : String
    property parent : Node?
    property g : Number::Primitive = Float64::INFINITY
    property f : Number::Primitive = Float64::INFINITY
    getter neighbor = Hash(Node, Number::Primitive).new

    def initialize(@name = ""); end

    def connect(node : Node, distance : Number::Primitive)
      @neighbor[node] = distance
      node.neighbor[self] = distance
    end

    def <=>(other : self)
      @f <=> other.f
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
