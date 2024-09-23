# frozen_string_literal: true

require_relative '../../lib/report_exception'

class TournamentsController < ApplicationController
  def create
    players_names = params[:players_names]
    name = params[:name]
    Rails.logger.info "Players: #{players_names}"
    Rails.logger.info "Tournament name: #{name}"

    create_tournament_service = ::CreateTournament.new

    begin
      match = create_tournament_service.call(players_names, name, 'liga')
      flash[:notice] = 'Tournament created successfully'
      render json: { message: 'Tournament created successfully', match_id: match.id }, status: :created
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
      flash[:alert] = 'An error occurred'
      render json: { error: 'An error occurred', details: e.message }, status: :internal_server_error
    end

    def new; end
  end
end
