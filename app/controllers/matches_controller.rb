# frozen_string_literal: true

class MatchesController < ApplicationController
  def create
    players = params[:players].values
    winner_name = params[:winner_name]
    created_by = params[:created_by]
    Rails.logger.info "Players: #{players}"
    Rails.logger.info "Winner: #{winner_name}"
    Rails.logger.info "Sent by: #{created_by}"

    create_match_service = ::CreateMatch.new

    begin
      match = create_match_service.call(players, winner_name, created_by, 'liga')
      flash[:notice] = 'Match created successfully'
      render json: { message: 'Match created successfully', match_id: match.id }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e.inspect)
      return unless e.respond_to?(:backtrace) && e.backtrace.present?

      Rails.logger.error(e.backtrace.join("\n"))
      Rails.logger.error("Player not found: #{e.message}")
      flash[:alert] = 'Player not found'
      render json: { error: 'Player not found', details: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(e.inspect)
      return unless e.respond_to?(:backtrace) && e.backtrace.present?

      Rails.logger.error(e.backtrace.join("\n"))
      Rails.logger.error("Record Invalid: #{e.record.errors.full_messages}")
      flash[:alert] = "Record Invalid: #{e.record.errors.full_messages}"
      render json: { error: 'Validation error', details: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error(e.inspect)
      return unless e.respond_to?(:backtrace) && e.backtrace.present?

      Rails.logger.error(e.backtrace.join("\n"))
      Rails.logger.error("StandardError: #{e.message}")
      flash[:alert] = 'An error occurred'
      render json: { error: 'An error occurred', details: e.message }, status: :internal_server_error
    end

    def new; end
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
                             @all_matches.length - 1
                           end

    @current_match = @all_matches[@current_match_index]
    @positions = PositionServices::Context.new(PositionServices::LastMatch.new)
                                          .execute(match: @current_match)
  end
end
