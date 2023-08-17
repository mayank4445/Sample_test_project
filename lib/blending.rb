module Blending
  
  extend ActiveSupport::Concern

  included do
    after_save :make_juice, if: :apple?
  end

  def make_juice
    # Logic for making juice
    puts "Juice is being made!"
  end

  private

  def apple?
    self.class == Apple
  end

end

