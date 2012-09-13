# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/home/cristian/bissen/ihome/tmp/cron_log.log"
set :environment, "development"

job_type :runner, "cd :path && rails runner -e :environment ':task' :output"

every 1.minutes do
  #runner "Profiles.runProfiles"
  # => command "runner -e development app/profiles_scheduler_controller.rb"
  runner 'Profile.destroyAll'
  #:path => '/home/cristian/bissen/ihome/app/models'
  command 'rm -rf /home/cristian/bissen/ihome/tmp/accesory.txt'
  #command "rails runner 'Profile.destroy_all'"
  #command "echo 'one' && echo 'two'"
end