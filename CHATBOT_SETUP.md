# AI Tutor Chatbot Setup Guide

This guide explains how to set up and configure the AI Tutor chatbot functionality in the Rails application.

## Overview

The AI Tutor chatbot provides personalized learning assistance to students using OpenAI's GPT models. Each user can have multiple chat sessions, one per subject, with context that adapts to their learning profile and progress.

## Features

- **Subject-specific chats**: Each chat session is tied to a specific subject
- **Personalized context**: AI adapts to user's learning style, progress, and notes
- **Real-time messaging**: AJAX-powered chat interface with typing indicators
- **Chat history**: All conversations are preserved and can be reviewed
- **Progress-aware**: AI considers user's timeline progress for tailored responses
- **Modern UI**: Clean, responsive chat interface with message bubbles and animations

## Database Schema

### New Models Added

1. **Chat**
   - `user_id` (references users)
   - `subject_id` (references subjects)
   - `system_prompt` (text)
   - `created_at`, `updated_at`

2. **ChatMessage**
   - `chat_id` (references chats)
   - `role` (string: 'user', 'assistant', 'system')
   - `content` (text)
   - `created_at`, `updated_at`

### Associations Added

- `User has_many :chats`
- `Subject has_many :chats`
- `Chat belongs_to :user, :subject` and `has_many :chat_messages`
- `ChatMessage belongs_to :chat`

## Setup Instructions

### 1. Install Dependencies

The following gems have been added to the Gemfile:
```ruby
gem 'openai'
```

Run bundle install:
```bash
bundle install
```

### 2. Run Database Migrations

Create and run the migrations for the new chat tables:
```bash
bin/rails db:create:migration CreateChats user:references subject:references system_prompt:text
bin/rails db:create:migration CreateChatMessages chat:references role:string content:text
bin/rails db:migrate
```

### 3. Configure OpenAI API

#### Option A: Using Rails Credentials (Recommended)
```bash
bin/rails credentials:edit
```

Add your OpenAI API key:
```yaml
openai_api_key: your_openai_api_key_here
openai_organization_id: your_org_id_here  # Optional
```

#### Option B: Using Environment Variables
Set the following environment variables:
```bash
export OPENAI_API_KEY=your_openai_api_key_here
export OPENAI_ORGANIZATION_ID=your_org_id_here  # Optional
```

### 4. Seed Sample Subjects

Add sample subjects to your database by running:
```bash
bin/rails db:seed
```

Or manually create subjects in the Rails console:
```ruby
sample_subjects = [
  { name: "Mathematics", category: "igcse" },
  { name: "English Language", category: "igcse" },
  { name: "Physics", category: "igcse" },
  { name: "Chemistry", category: "igcse" },
  { name: "Biology", category: "igcse" },
  { name: "History", category: "igcse" },
  { name: "Geography", category: "igcse" },
  { name: "Computer Science", category: "igcse" },
  { name: "Art & Design", category: "igcse" },
  { name: "Spanish", category: "lang" }
]

sample_subjects.each do |subject_attrs|
  Subject.find_or_create_by(name: subject_attrs[:name]) do |subject|
    subject.category = subject_attrs[:category]
  end
end
```

### 5. Update Routes (Already Done)

The following routes have been added to `config/routes.rb`:
```ruby
resources :chats do
  member do
    post :send_message
  end
end
```

### 6. Navigation Link (Already Added)

The AI Tutor link has been added to the main navigation in `app/views/shared/_navbar.html.erb`.

## Usage

### Accessing the Chat

1. Users can access the AI Tutor through the navigation menu
2. Select a subject from the dropdown to start a new chat session
3. Type messages and receive personalized AI responses
4. Switch subjects to create separate chat sessions

### System Prompt Generation

The AI context is automatically generated based on:
- User's full name, level, nationality, and language preferences
- User's notes (from the existing Notes model)
- Subject-specific timeline progress
- Learning balance and expected progress

Example system prompt:
```
You are a tutor chatbot for John Doe.

Student Information:
- Level: IGCSE
- Nationality: Spanish
- Native English Speaker: No
- Notes: Math: struggling with algebra (Action: extra practice); Science: strong in physics

Subject: Mathematics
Progress: 75%, Expected: 80%, Balance: -5

Tailor your explanations to this learner's needs and focus on the selected subject.
Be encouraging, clear, and adapt your language level appropriately.
If the student is struggling (negative progress balance), offer additional support and break down concepts more simply.
```

## File Structure

### Models
- `app/models/chat.rb` - Chat model with associations and system prompt generation
- `app/models/chat_message.rb` - ChatMessage model with validations

### Controllers
- `app/controllers/chats_controller.rb` - Handles chat creation, messaging, and history

### Services
- `app/services/chatbot_service.rb` - OpenAI API integration and response generation

### Views
- `app/views/chats/index.html.erb` - Chat selection and history
- `app/views/chats/show.html.erb` - Main chat interface with real-time messaging

### Configuration
- `config/initializers/openai.rb` - OpenAI client configuration

## API Configuration

### OpenAI Settings
- Model: `gpt-3.5-turbo`
- Max tokens: 500
- Temperature: 0.7
- Message history: Last 10 messages (to stay within token limits)

### Error Handling
- API failures fall back to a friendly error message
- Network issues are logged and handled gracefully
- User messages are always saved regardless of API success

## Customization

### Modifying the AI Behavior
Edit the `generate_system_prompt` method in `app/models/chat.rb` to adjust how the AI context is created.

### Changing the UI
The chat interface uses Bootstrap 5 classes and custom CSS. Modify `app/views/chats/show.html.erb` for layout changes.

### Adding New Features
- Message attachments: Extend ChatMessage model
- Voice messages: Add audio processing
- Message reactions: Add reaction model and UI
- Chat sharing: Add permission system

## Security Considerations

1. **API Key Protection**: Never commit API keys to version control
2. **User Authorization**: Only users can access their own chats
3. **Content Filtering**: Consider adding content moderation for inappropriate messages
4. **Rate Limiting**: Implement rate limiting to prevent API abuse

## Troubleshooting

### Common Issues

1. **OpenAI API Key Not Working**
   - Verify the key is correctly set in credentials or environment
   - Check that you have sufficient OpenAI credits
   - Ensure the key has the correct permissions

2. **Database Errors**
   - Run `bin/rails db:migrate` to ensure all migrations are applied
   - Check that foreign key relationships are properly set up

3. **JavaScript Not Working**
   - Ensure Turbo is properly configured
   - Check browser console for JavaScript errors
   - Verify that CSRF tokens are properly handled

4. **Styling Issues**
   - Ensure Bootstrap 5 is properly loaded
   - Check that Font Awesome icons are available

### Logs and Debugging

- OpenAI API errors are logged to `Rails.logger`
- Check `log/development.log` for detailed error information
- Use browser dev tools to debug AJAX requests

## Performance Considerations

1. **Token Limits**: Messages are truncated to stay within OpenAI token limits
2. **API Response Time**: Consider adding loading states for better UX
3. **Database Queries**: Chat messages are eager loaded to prevent N+1 queries
4. **Caching**: Consider caching frequently accessed subject data

## Future Enhancements

- **Multi-language Support**: Adapt AI responses to user's preferred language
- **Voice Integration**: Add speech-to-text and text-to-speech
- **File Uploads**: Allow students to share homework for AI review
- **Study Plans**: Generate personalized study schedules
- **Assessment Integration**: Connect with existing assignment system
- **Analytics**: Track chat usage and learning outcomes

## Support

For technical issues or feature requests, contact the development team or create an issue in the project repository.
