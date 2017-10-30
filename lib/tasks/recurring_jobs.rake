namespace :recurring do
  task init: :environment do
    IntegratorTask.schedule!

#    if Rails.env.production?
#      MyProductionOnlyTask.schedule!
#    end

  end
end
