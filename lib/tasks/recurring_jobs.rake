namespace :recurring do
  task init: :environment do

    worker_interval = APP_CONFIG['worker_interval']
    IntegratorTask.schedule!(run_every: worker_interval.seconds)

#    if Rails.env.production?
#      MyProductionOnlyTask.schedule!
#    end

  end
end
