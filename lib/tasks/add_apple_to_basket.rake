# lib/tasks/add_apple_to_basket.rake

namespace :apples do
  desc "Add apples to baskets: rails apples:add_apple_to_basket variety=RED count=10"
  task add_apple_to_basket: [:environment] do |_, args|
    variety = ENV['variety'].to_s
    count = ENV['count'].to_i
    puts variety
    puts count
    # Find an available basket
    available_basket = Basket.left_outer_joins(:apples)
                            .where("capacity > ?", 0)
                            .where("fill_rate < 100 OR fill_rate IS NULL")
                            .where("apples.variety = ? OR apples.id IS NULL", variety)
                            .first

    if available_basket.nil?
      puts "All baskets are full. We couldn't find the place for #{count} apples"
      return
    end

    # Calculate the fill_rate and determine how many apples can fit in the basket
    current_fill = available_basket.apples.count
    remaining_capacity = available_basket.capacity - current_fill
    actual_count = [count, remaining_capacity].min

    # Create apple records
    Apple.transaction do
      actual_count.times do
        Apple.create!(basket: available_basket, variety: variety)
      end
    end

    # Recalculate fill_rate for the basket
    new_fill = current_fill + actual_count
    fill_rate = (new_fill.to_f / available_basket.capacity) * 100

    # Update the fill_rate of the basket
    available_basket.update(fill_rate: fill_rate)
  end
end
