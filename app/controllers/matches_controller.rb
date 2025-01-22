# frozen_string_literal: true

require_relative '../../lib/report_exception'

class MatchesController < ApplicationController
  def create
    players = params[:players].values
    winner_name = params[:winner_name]
    created_by = params[:created_by]

    create_match_service = ::CreateMatch.new

    begin
      match = create_match_service.call(players, winner_name, created_by, 'liga')
      ::MatchPositionsServices::Create.new.execute(tournament: Tournament.last, winner_points: 2, match_id: match.id)
      flash[:notice] = 'Match created successfully'
      render json: { message: 'Match created successfully', match_id: match.id }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      report_exception(e)
      flash[:alert] = 'Player not found'
      render json: { error: 'Player not found', details: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      report_exception(e)
      flash[:alert] = "Record Invalid: #{e.record.errors.full_messages}"
      render json: { error: 'Validation error', details: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      report_exception(e)
      flash[:alert] = e.message.present? ? e.message : 'An error occurred'
      render json: { error: 'An error occurred', details: e.message }, status: :internal_server_error
    end
  end

  def new
    @last_match = ::Match.last
  end

  def index
    tournament = Tournament.last # Tournament.where(tournament_type: 'liga').last
    last_match = tournament.matches.last
    if last_match
      redirect_to match_path(id: last_match.id)
    else
      # Handle the case where there are no matches
      redirect_to tournament, alert: 'No matches available for this tournament.'
    end
  end

  def show
    @all_matches = Match.where(tournament: Tournament.last).order(:created_at)
    @current_match_index = if params[:id]
                             @all_matches.find_index do |m|
                               m.id == params[:id].to_i
                             end
                           else
                             @all_matches.size - 1
                           end

    @current_match = @all_matches[@current_match_index]
    @positions = PositionServices::Context.new(PositionServices::LastMatch.new)
                                          .execute(match: @current_match)
  end
end
