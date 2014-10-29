class CreateManualChargesModels < ActiveRecord::Migration
  def change
    create_table :manual_charges_models do |t|

      t.timestamps
    end
  end
end
