require 'rails_helper'

RSpec.feature "Visitor can add items to their cart", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name: Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 69.99
      )
    end
  end

  scenario "They can see the cart number update after clicking add" do
    # ACT
    visit root_path

    within ".products" do
      first(:button, 'Add').click
    end

    # VERIFY
    expect(page).to have_text 'My Cart (1)'
    save_screenshot
  end
end