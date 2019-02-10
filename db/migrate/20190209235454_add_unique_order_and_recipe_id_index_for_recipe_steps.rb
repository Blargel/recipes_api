class AddUniqueOrderAndRecipeIdIndexForRecipeSteps < ActiveRecord::Migration[5.2]
  def change
    add_index :recipe_steps, [:recipe_id, :order], unique: true
  end
end
