# Learn more: http://github.com/javan/whenever

# Make sure cron sees the right Ruby & gems (rbenv first)
env :PATH, "/Users/xico/.rbenv/shims:/Users/xico/.rbenv/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Log cron output here
set :output, "/Users/xico/code/xicofigueiredo/worktools/log/cron.log"

# Use development environment
set :environment, :development

# Tell Whenever to run all jobs via `bundle exec ...`
# (with PATH including ./bin, "bundle" will resolve to ./bin/bundle)
set :bundle_command, "bundle exec"

# Use a non-login shell so our PATH from env :PATH is *not* overridden
set :job_template, "/bin/bash -c ':job'"

# Your daily job (local testing time)
every 1.day, at: '12:30 pm' do
  rake "learner_info:daily_maintenance"
end
