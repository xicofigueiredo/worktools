namespace :db do
  desc "Check if specified emails exist in the database and output missing ones"
  task check_emails_exist: :environment do
    emails_to_check = %w[
      aleksander.sielewicz@edubga.com
      arran.hem@edubga.com
      Bruno.Oliveira@edubga.com
      daria.velichko@edubga.com

      Loze.Majiedt@edubga.com
      malia.doughty@edubga.com
      muhammed.lulat@edubga.com
      nahid.salimi@brave-future.com
      nathan.garnel@edubga.com
      Paul.Bievre@edubga.com
      rocco.vanrumpt@edubga.com
      rotem.edry@edubga.com
      sophie.kremer@edubga.com
      tania.venter@edubga.com
      tanisha.hillegonda@edubga.com
      tara.Boer@edubga.com
      theana.figenschou@edubga.com
      cori.blank@edubga.com
    ]
    puts "Checking #{emails_to_check.count} emails..."

    # Find missing emails
    missing_emails = emails_to_check.reject do |email|
      User.exists?(email: email.downcase)
    end

    # Output the result
    if missing_emails.any?
      puts "The following emails were not found in the database:"
      puts missing_emails
      puts "Total: #{missing_emails.count}"
    else
      puts "All emails are present in the database."
    end
  end
end
