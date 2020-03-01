require 'rails_helper'

RSpec.describe "pieces/edit", type: :view do
  before(:each) do
    @piece = assign(:piece, Piece.create!())
  end

  it "renders the edit piece form" do
    render

    assert_select "form[action=?][method=?]", piece_path(@piece), "post" do
    end
  end
end
