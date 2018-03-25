require "./spec_helper"

describe AStar do
  it "search direct path from A to B" do
    a = AStar::Node.new "A"
    b = AStar::Node.new "B"

    a.connect b, 3
    
    AStar.new { |node1, node2| 0 }.search(a, b).should eq([a, b])
  end

  it "search shortest path of two possible" do
    a = AStar::Node.new "A"
    b = AStar::Node.new "B"
    c = AStar::Node.new "C"
    d = AStar::Node.new "D"

    # long route
    a.connect b, 1
    b.connect c, 3
    c.connect d, 2

    # short route 
    b.connect d, 1

    AStar.new { |node1, node2| 0 }.search(a, d).should eq([a, b, d])
  end

  it "no possible path" do
    a = AStar::Node.new "A"
    b = AStar::Node.new "B"
    c = AStar::Node.new "C"

    # no connection to goal
    a.connect b, 2

    AStar.new { |node1, node2| 0 }.search(a, c).should be_nil
  end
end


  it "works" do
    false.should eq(true)
  end
end
