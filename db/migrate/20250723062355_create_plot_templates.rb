class CreatePlotTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :plot_templates do |t|
      t.string :name
      t.text :description
      t.text :body

      t.timestamps
    end
  end
end
