class AddCreatedByToMatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :matches, :created_by, null: false, foreign_key: { to_table: :players, on_delete: :nullify },
                                         default: 1
  end
end
