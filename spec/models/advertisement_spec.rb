require 'rails_helper'

RSpec.describe Advertisement, type: :model do

  let(:advertisement) { Advertisement.create!(title: "New Ad Title", copy: "New Ad Body", price: 9) }

  describe "attributes" do
    it "has title, copy, and price attributes" do
      expect(advertisement).to have_attributes(title: "New Ad Title", copy: "New Ad Body", price: 9)
    end
  end
  describe "responds" do
    it "responds to title" do
      expect(advertisement).to respond_to(:title)
    end
    it "responds to title" do
      expect(advertisement).to respond_to(:copy)
    end
    it "responds to title" do
      expect(advertisement).to respond_to(:price)
    end
  end
end
