# iOS Chatbot Demo with SwiftUI

A simple and elegant iOS chatbot application built with SwiftUI, demonstrating the integration of [Exyte's Chat library](https://github.com/exyte/Chat) and [MacPaw's OpenAI library](https://github.com/MacPaw/OpenAI).

## 🎯 Features

- **Modern SwiftUI Interface**: Clean and responsive chat UI
- **Real-time Messaging**: Send and receive messages with typing indicators
- **OpenAI Integration**: Powered by GPT models for intelligent responses
- **Conversation Context**: Maintains chat history for contextual responses
- **Error Handling**: Graceful error handling with user-friendly messages

## 📱 Demo

<video width="800" controls>
  <source src="https://github.com/user-attachments/assets/201578ea-2758-43b8-befc-9f7b426d07f2" type="video/mp4">
  Your browser does not support the video tag.
</video>

## 🛠 Tech Stack

- **SwiftUI**: Apple's declarative UI framework
- **[ExyteChat](https://github.com/exyte/Chat)**: Beautiful and customizable chat UI components
- **[OpenAI by MacPaw](https://github.com/MacPaw/OpenAI)**: Swift package for OpenAI API integration
- **iOS 15.0+**: Minimum deployment target

## 🚀 Getting Started

### Prerequisites

- Xcode 14.0 or later
- iOS 15.0 or later
- An OpenAI API key (you can get one for free [here](https://platform.openai.com/signup))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/GuillaumeBlanchet/chatbot.git
   cd chatbot
   ```

2. **Open in Xcode**
   ```bash
   open chatbot.xcodeproj
   ```

3. **Install Dependencies**
   
   The project uses Swift Package Manager. Dependencies will be automatically resolved when you open the project:
   - ExyteChat (v2.6.5)
   - OpenAI by MacPaw (v0.4.6)
   - Additional UI components (ActivityIndicatorView, MediaPicker, etc.)

4. **Configure OpenAI API Key**
   
   ⚠️ **Important**: Replace the placeholder API key in `ChatViewModel.swift`
   
   ```swift
   // In ChatViewModel.swift, line 28
   self.openAI = OpenAI(apiToken: "YOUR_OPENAI_API_KEY_HERE")
   ```
   
   > **Security Note**: For production apps, store your API key securely in the Keychain instead of hardcoding it.

5. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 📁 Project Structure

```
chatbot/
├── chatbot/
│   ├── chatbotApp.swift          # Main app entry point
│   ├── ContentView.swift         # Root view
│   ├── ChatView.swift            # Main chat interface
│   ├── ChatViewModel.swift       # Chat logic and OpenAI integration
│   └── DotLoadingView.swift      # Loading animation component
└── README.md
```

## 🔧 Key Components

### ChatViewModel
The heart of the application that handles:
- Message management and state
- OpenAI API communication
- Conversation context and history
- Error handling and fallbacks

### ChatView (ChatGoalView)
The main chat interface built with ExyteChat:
- Text input handling
- Message display
- Navigation setup

### Features Implemented
- **Conversation Context**: Maintains last 10 messages for context
- **Streaming Support**: Ready for streaming responses (currently disabled)
- **User/Bot Detection**: Uses user ID to differentiate between user and bot messages [[memory:6726145]]
- **Custom System Prompt**: Configured for cheerful, concise responses

## 🎨 Customization

### Modify the Bot Personality
Edit the system prompt in `ChatViewModel.swift`:

```swift
.system(.init(content: .textContent("Your custom bot personality here")))
```

### Change the UI Theme
The ExyteChat library supports extensive customization. Refer to their [documentation](https://github.com/exyte/Chat) for styling options.

### Switch OpenAI Models
Modify the model in the ChatQuery:

```swift
let query = ChatQuery(
    messages: chatMessages, 
    model: .gpt4, // or .gpt3_5Turbo, etc.
    stream: false
)
```

## ⚠️ Important Notes

- **API Key Security**: Never commit your OpenAI API key to version control
- **Rate Limiting**: Be aware of OpenAI API rate limits and costs
- **Error Handling**: The app includes basic error handling but can be enhanced for production

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## 📄 License

This project is a demo and is provided as-is for educational purposes.

## 🔗 Resources

- [ExyteChat Documentation](https://github.com/exyte/Chat)
- [MacPaw OpenAI Swift Package](https://github.com/MacPaw/OpenAI)
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

