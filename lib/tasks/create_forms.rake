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

  desc "Create sports form for all learners"
  task create_sports_form: :environment do
    # Define the questions with their types and options
    questions = [
      {
        content: "Do you play competitive sports?",
        question_type: "yes_no",
        options: nil
      },
      {
        content: "What sport do you play?",
        question_type: "dropdown",
        options: [
          "Football", "Futsal", "Basketball", "Handball", "Roller Hockey",
          "Volleyball", "Rugby", "Swimming", "Athletics", "Tennis", "Padel",
          "Cycling", "Surfing", "Bodyboarding", "Sailing", "Canoeing", "Golf",
          "Motorsports", "Gymnastics", "Judo", "Other"
        ]
      },
      {
        content: "What club do you represent?",
        question_type: "text",
        options: nil
      },
      {
        content: "What competitions do you play?",
        question_type: "dropdown",
        options: ["National", "International"]
      },
      {
        content: "What are your ambitions in the sport?",
        question_type: "dropdown",
        options: [
          "Hobby",
          "Be a top performer at an amateur level",
          "Be/Become a professional athlete"
        ]
      }
    ]

    # Create the form
    form = Form.create!(
      title: "Sports Information Form - #{Time.zone.today.strftime('%B %Y')}",
      scheduled_date: Time.zone.today
    )

    # Create interrogations and link them to the form
    questions.each do |question_data|
      interrogation = Interrogation.create!(
        content: question_data[:content],
        question_type: question_data[:question_type],
        options: question_data[:options] ? question_data[:options].to_json : nil
      )
      FormInterrogationJoin.create!(form: form, interrogation: interrogation)
    end

    puts "Created sports form '#{form.title}' with #{questions.size} questions."
    puts "Form ID: #{form.id}"

    # Create notifications for all active learners
    learners = User.where(role: 'learner', deactivate: [false, nil])
    lcs = User.where(role: 'lc', deactivate: [false, nil])
    form_link = Rails.application.routes.url_helpers.new_form_response_path(form)

    notifications_count = 0
    learners.find_each do |learner|
      Notification.create!(
        user: learner,
        message: "A new form '#{form.title}' is available. Please complete it when you have a moment.",
        link: form_link,
        read: false
      )
      notifications_count += 1
    end

    lcs.find_each do |lc|
      Notification.create!(
        user: lc,
        message: "A form regarding sports activities has been sent to all learners. Please ensure they complete it.",
        read: false
      )
      notifications_count += 1
    end

    puts "Created #{notifications_count} notifications."
    puts "Form link: #{form_link}"
  end
end
