require 'prawn'
require 'prawn/measurement_extensions'

class WelcomeLetterGenerator
  TEMPLATE_PATH = Rails.root.join('public', 'documents', 'welcome_letter_background.png')

  def initialize(learner_name)
    @learner_name = learner_name
  end

  def generate
    Tempfile.create(['welcome_letter', '.pdf']) do |tempfile|
      Prawn::Document.generate(tempfile.path, page_size: 'A4', margin: 0) do |pdf|
        # Add background image if it exists
        if File.exist?(TEMPLATE_PATH)
          pdf.image TEMPLATE_PATH, at: [0, pdf.bounds.top - 10], width: pdf.bounds.width, height: pdf.bounds.height
        end

        pdf.font 'Helvetica', size: 12

        # Main content area - adjust these coordinates based on your template
        pdf.bounding_box([72, pdf.bounds.top - 120], width: pdf.bounds.width - 144) do

          # Greeting
          pdf.text "Dear #{@learner_name},", align: :left
          pdf.move_down 36

          # Paragraph 1
          pdf.text "It is with immense joy and excitement that we extend to you our warmest congratulations on your acceptance to Brave Generation Academy!",
                   align: :justify,
                   leading: 3
          pdf.move_down 18

          # Paragraph 2
          pdf.text "After reviewing your application and getting to know you better, we were thoroughly impressed by your courage, determination, and passion for blazing your own trail. At Brave Generation Academy, we recognise that each Learner is a unique individual with their own passions. We believe in fostering an environment where Learners like you can fearlessly embrace their authenticity and take charge of their educational journey.",
                   align: :justify,
                   leading: 3
          pdf.move_down 18

          # Paragraph 3
          pdf.text "By choosing to join the Brave Generation, you are embarking on a remarkable adventure. Here at BGA, we don't just follow the path; we create our own. Our innovative learning model empowers Learners to both think critically and make a positive impact in the world around them.",
                   align: :justify,
                   leading: 3
          pdf.move_down 18

          # Paragraph 4
          pdf.text "As a member of our international community, you will have access to a wealth of resources and support to help you thrive both academically and personally. Whatever you're passionate about, you'll find a home at Brave Generation Academy.",
                   align: :justify,
                   leading: 3
          pdf.move_down 18

          # Paragraph 5
          pdf.text "We can't wait to welcome you and witness the incredible contributions you will undoubtedly make to our community. Get ready to embark on an unforgettable journey of self-discovery, exploration, and growth. Your bravery has brought you here, and now the adventure truly begins!",
                   align: :justify,
                   leading: 3
          pdf.move_down 36

          # Closing
          pdf.text "Be Brave,", align: :left
          pdf.move_down 18
          pdf.font("Helvetica", style: :bold) { pdf.text "The BGA Team", align: :left }
        end
      end

      # Read the generated PDF content
      tempfile.rewind
      tempfile.read
    end
  end
end
