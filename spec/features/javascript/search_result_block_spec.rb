require "spec_helper"

describe "Search Results Block", js: true do
  let(:exhibit) { FactoryGirl.create(:exhibit) }
  let(:exhibit_curator) { FactoryGirl.create(:exhibit_curator, exhibit: exhibit) }
  let!(:feature_page) { FactoryGirl.create(:feature_page, exhibit: exhibit) }
  let!(:alt_search) { FactoryGirl.create(:search, title: "Alt. Search", exhibit: exhibit) }

  before { login_as exhibit_curator }
  it "should allow a curator to select from existing browse categories" do
    pending("Passing locally but Travis is throwing intermittent errors") if ENV["CI"]
    visit spotlight.exhibit_home_page_path(exhibit, exhibit.home_page)
    click_link exhibit_curator.email
    within '#user-util-collapse .dropdown' do
      click_link 'Dashboard'
    end
    click_link "Feature pages"

    within("[data-id='#{feature_page.id}']") do
      click_link "Edit"
    end

    find("[data-icon='add']").click

    find("a[data-type='search_results']").click

    # Drop down should exist with all browse categories listed
    within("select[name='searches-options']") do
      expect(page).to have_css("option", text: "All Exhibit Items", visible: true)
      expect(page).to have_css("option", text: "Alt. Search", visible: true)
      expect(page).to have_css("option[value='#{alt_search.id}']", visible: true)
    end

    select("All Exhibit Items", from: "Browse category")

    check "gallery"
    check "slideshow"

    click_button "Save changes"

    expect(page).to have_content("The feature page was successfully updated.", visible: true)

    # The two configured view types should be
    # present and the one not selected should not be
    within(".view-type-group") do
      expect(page).not_to have_css(".view-type-list")
      expect(page).to     have_css(".view-type-gallery")
      expect(page).to     have_css(".view-type-slideshow")
    end

    # Documents should exist
    expect(page).to have_css(".documents .document")
  end
end