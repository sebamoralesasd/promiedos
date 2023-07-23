# frozen_string_literal: true

class History
  def call
    Match.all.each do |m|
      puts "Partido #{m.id - 1}: \n"
      m.players
       .order(:name)
       .each { |pl| puts pl.name }
      puts "Ganador: #{m.winner.name}\n\n"
    end

    nil
  end
end
