require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    before(:example) do
      Category.create(name: 'Test Products')
    end
    it 'saves successfully when all required fields are present' do
      product = Product.new name: 'Flanger',
        price: 100,
        quantity: 50,
        category: Category.find_by(name: 'Test Products')

      product.save!
      expect(product.id).to be_a Numeric
    end
    it 'fails when no name is specified' do
      product = Product.new price: 100,
        quantity: 50,
        category: Category.find_by(name: 'Test Products')

      product.save
      expect(product.errors.full_messages).to include /name/i
    end
    it 'fails when no price is specified' do
      product = Product.new name: 'Flanger',
        quantity: 50,
        category: Category.find_by(name: 'Test Products')

      product.save
      expect(product.errors.full_messages).to include /price/i
    end
    it 'fails when no quantity is specified' do
      product = Product.new name: 'Flanger',
        price: 100,
        category: Category.find_by(name: 'Test Products')

      product.save
      expect(product.errors.full_messages).to include /quantity/i
    end
    it 'fails when no category is specified' do
      product = Product.new name: 'Flanger',
        price: 100,
        quantity: 50

      product.save
      expect(product.errors.full_messages).to include /category/i
    end
  end
end