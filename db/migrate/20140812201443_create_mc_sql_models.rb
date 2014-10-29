class CreateMcSqlModels < ActiveRecord::Migration
  def change
    create_table :mc_sql_models do |t|

      t.timestamps
    end
  end
end
