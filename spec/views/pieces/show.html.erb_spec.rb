require 'rails_helper'

RSpec.describe "pieces/show", type: :view do
  before(:each) do
    @piece = assign(:piece, Piece.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
