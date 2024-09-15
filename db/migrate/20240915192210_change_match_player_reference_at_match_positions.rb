class ChangeMatchPlayerReferenceAtMatchPositions < ActiveRecord::Migration[7.0]
  def change
    remove_reference :match_positions, :match_player
    add_reference :match_positions, :match
    add_reference :match_positions, :player
  end
end
