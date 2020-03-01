require 'rails_helper'

RSpec.describe "pieces/index", type: :view do
  before(:each) do
    assign(:pieces, [
      Piece.create!(),
      Piece.create!()
    ])
  end

  it "renders a list of pieces" do
    render
  end
end
