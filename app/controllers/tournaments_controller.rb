# frozen_string_literal: true

class TournamentsController < ApplicationController
  def create
    players_names = params[:players_names]
    name = params[:name]
    Rails.logger.info "Players: #{players_names}"
    Rails.logger.info "Tournament name: #{name}"

    create_tournament_service = ::CreateTournament.new

    begin
      match = create_tournament_service.call(players_names, name)
      flash[:notice] = 'Tournament created successfully'
      render json: { message: 'Tournament created successfully', match_id: match.id }, status: :created
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
end
