require 'spec_helper'

module Spotlight
  describe "spotlight/appearances/edit" do
    let(:exhibit) { FactoryGirl.create(:exhibit) } 
    let(:appearance) { Spotlight::Appearance.new(exhibit.blacklight_configuration) }
    before do
      assign(:exhibit, exhibit)
      assign(:appearance, appearance)
      view.stub(current_exhibit: exhibit)
    end

    it "should have a disabled relevance sort option" do
      render

      expect(rendered).to have_selector "input[name='appearance[sort_fields][relevance]'][disabled='disabled']"
    end
  end
end

