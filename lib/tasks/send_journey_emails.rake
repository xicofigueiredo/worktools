namespace :db do
  desc "Send journey emails to all parents"
  task send_journey_emails: :environment do
    parents = User.where(role: 'Parent')
    total = parents.count
    sent = 0
    failed = 0

    puts "Starting to send journey emails to #{total} parents..."

    parents.find_each do |parent|
      kids = User.where(id: parent.kids)
      boolean = false
      kids.each do |kid|
        if kid.deactivate != true
          boolean = true
        end
      end
      if boolean
        begin
          UserMailer.parent_journey_email(parent).deliver_now
          sent += 1
          puts "Sent email to #{parent.email} (#{sent}/#{total})"
        rescue => e
          failed += 1
          puts "Failed to send email to #{parent.email}: #{e.message}"
        end
      end
    end

    puts "\nSummary:"
    puts "Total parents: #{total}"
    puts "Emails sent: #{sent}"
    puts "Failed: #{failed}"
  end
end
