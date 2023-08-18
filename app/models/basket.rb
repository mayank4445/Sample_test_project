class Basket < ApplicationRecord
	has_many :apples

  def add_apples(variety, count)
    available_space = capacity - apples.count
    actual_count = [count, available_space].min

    if actual_count > 0
      Apple.transaction do
        actual_count.times do
          apples.create!(variety: variety)
        end
      end

      new_fill_rate = (apples.count.to_f / capacity) * 100
      update(fill_rate: new_fill_rate)

      remaining_apples = count - actual_count
      remaining_apples.positive? ? next_basket.add_apples(variety, remaining_apples) : true
    else
      false
    end
  end

  def next_basket
    Basket.where("id > ?", id).order(id: :asc).first
  end
end
