class IntegratorTask
  include Delayed::RecurringJob
  run_every 5.minutes
  queue 'intg-jobs'

  require_relative '../services/sync_service'

  def perform
    s = SyncService.new
    s.sync_reservations_and_update_availability
  end
end