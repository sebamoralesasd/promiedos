class MatchesController < ApplicationController
  def create
    players_names = params[:players_names]
    winner_name = params[:winner_name]

    create_match_service = CreateMatch.new

    begin
      match = create_match_service.call(players_names, winner_name)
      render json: { message: 'Match created successfully', match_id: match.id }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Player not found', details: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: 'Validation error', details: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: 'An error occurred', details: e.message }, status: :internal_server_error
    end
  end
end
