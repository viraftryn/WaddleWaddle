🐣**WADDLE - Daily Water Reminder**🐣
Waddle is a SwiftUI-based iOS application that promotes healthy hydration habits by calculating and tracking individual water intake needs. 
This app integrates motion sensing and notifications for a more interactive and timely user experience.

🚀 Features
- Personalized intake recommendation based on weight, height, gender, and activity level
- Daily progress bar with reset functionality
- Shake gesture to log water intake (via CoreMotion)
- Daily reminders using local notifications
- Smooth navigation using NavigationStack and custom routing
- User data persistence with UserDefaults
- Clean, animated onboarding experience

👩🏻‍💻 Technologies Used
- SwiftUI: Declarative UI framework for building native UIs across all Apple platforms
- NavigationPath: Handles dynamic routing in a single NavigationStack using enums
- UserDefaults: Stores user data such as profile and intake progress
- CoreMotion: Implements shake gesture detection for logging intake
- UserNotifications: Schedules local notifications to remind users to drink wate

📁 Project Structures
WaddleWaddle/
├── Assets.xcassets/              # App icons and UI assets
├── ContentView.swift             # Onboarding forms
├── Notification.swift            # Notification scheduling logic
├── ShakeDetector.swift           # Shake gesture detection
├── UserData.swift                # Handles user data and state
├── WelcomePage.swift             # Animated welcome screen + routing setup and root view controller
├── Page_*.swift                  # Step-by-step onboarding forms
├── Page_Main.swift               # Home screen with progress tracking
├── Page_Profile.swift            # User profile summary and update
├── WaddleWaddleApp.swift         # App entry point
└── WaddleNotification.wav        # Custom notification sound

🧠 Problem-Solving & Coding Style
- To simplify screen transitions and make routing scalable, this project uses a centralized enum **Route** to define all possible screens. It is passed into the **NavigationStack** using a single source of truth (**path**) and resolved with **.navigationDestination**.
- We used **@StateObject** and **@Binding** to ensure user progress and input are preserved across views. Only the root view holds the **NavigationPath**, while others receive it via bindings. This keeps the navigation flow clean and centralized.
- A **ShakeDetector** class detects physical device motion and triggers water intake logging. This adds an engaging and interactive layer to the app experience.
- User-defined reminders are handled using **UserNotifications**. We also prompt the user for notification permissions on first launch with clear UX flows.
