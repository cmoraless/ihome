# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

#env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/cristian/bissen/ihome/vendor/bundle/ruby/1.9.1/bin'
#set :path, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/cristian/bissen/ihome/vendor/bundle/ruby/1.9.1/bin'

#set :output, "/home/cristian/bissen/ihome/tmp/cron_log.log"
set :output, "log/profiles.log"
#set :path, "/home/cristian/bissen/ihome"
set :environment, "development"

every 1.minutes do
  #runner "Profiles.runProfiles"
  runner "Profile.destroyAll"
end