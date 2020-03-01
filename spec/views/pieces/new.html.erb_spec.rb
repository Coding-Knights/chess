require 'rails_helper'

RSpec.describe "pieces/new", type: :view do
  before(:each) do
    assign(:piece, Piece.new())
  end

  it "renders new piece form" do
    render

    assert_select "form[action=?][method=?]", pieces_path, "post" do
    end
  end
end
