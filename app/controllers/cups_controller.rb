# frozen_string_literal: true

class CupsController < ApplicationController
  def index
    @tournament = Tournament.where(tournament_type: 'copa').last
    @positions = PositionServices::Context.new(PositionServices::Average.new)
                                          .execute(tournament: @tournament, winner_points: 2)
  end

  def create
    players = params[:players].values
    winner_name = params[:winner_name]
    Rails.logger.info "Players: #{players}"
    Rails.logger.info "Winner: #{winner_name}"

    create_match_service = ::CreateMatch.new

    begin
      match = create_match_service.call(players, winner_name, 'copa')
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
  end

  # def last
  #   match = Match.where(tournament: Tournament.where(tournament_type: 'liga').last).last
  #   @positions = PositionServices::Context.new(PositionServices::LastMatch.new)
  #                                         .execute(match:)
  # end
end
