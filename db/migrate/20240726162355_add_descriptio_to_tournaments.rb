class AddDescriptioToTournaments < ActiveRecord::Migration[7.0]
  def change
    desc = 'Se computan puntos ganados sobre partidos jugados. Sumandose 2 puntos al ganador de la partida. Para que sea válida la participación de un jugador en búsqueda del título tiene que haber jugado al menos la mitad de catanes del jugador con más presencias. Solo son válidos los catanes de 4,5 o 6 jugadores. La última fecha del torneo puede ser como máximo antes del cambio de estación. Los catanes viajeros no computan. El premio está a definirse. En caso de igualdad de porcentaje, gana el torneo el que mas catanes ganados tenga.'
    add_column :tournaments, :description, :text, null: false, default: desc
  end
end
