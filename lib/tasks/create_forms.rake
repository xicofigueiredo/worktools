# lib/tasks/create_forms.rake
namespace :forms do
  desc "Create a form for every subject with predefined interrogations"
  task create_for_subjects: :environment do
    # List of interrogations
    interrogations = [
      "How easy do you feel the course navigation is?",
      "What are your thoughts on the course assignments (CGAs, CMMAs, MAs, Mocks)?",
      "How do you feel about the feedback, written and spoken, that you are given?",
      "How beneficial are the live sessions (exam prep, workshops, office hours) that you attend?"
    ]

    # Fetch all subjects (assuming you have a Subject model)
    subjects = Subject.all

    if subjects.empty?
      puts "No subjects found. Please ensure you have subjects in the database."
      next
    end

    subjects.each do |subject|

      form = Form.create!(
        title: "Feedback for #{subject.name} - #{Time.zone.today.strftime('%B %Y')}",
        scheduled_date: Time.zone.today
        )

      interrogations.each do |content|
        interrogation = Interrogation.create!(content: content)
        FormInterrogationJoin.create!(form: form, interrogation: interrogation)
      end

      puts "Created form for #{subject.name} with #{interrogations.size} interrogations."
    end

    puts "Forms created successfully for all subjects."
  end
end
