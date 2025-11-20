# Once in Mind

<img width="1000" height="480" alt="Home Page (1)" src="https://github.com/user-attachments/assets/f4486b05-c708-4c40-89e7-42217ca0b507" />


A Flutter journaling application that provides a private space for users to express their feelings and share memories with their future self.

## ✨ Features

- **Journal Entries**: Create entries with text, multiple images, mood tracking, and master password protection
- **Location & Weather**: Add your location when writing a journal entry, and the weather will be added automatically.
- **Calendar View**: Browse entries by date
- **Gallery**: View all journal images in one place
- **Search**: Find specific journal entries quickly
- **Authentication**: Secure sign-up/sign-in with Firebase
- **Master Password Lock**: You can lock any journal entry individually for extra privacy.

## 🛠️ Tech Stack

**Frontend:** Flutter, BLoC Pattern, GoRouter

**Backend:** Firebase (Auth & Firestore), Supabase (Image Storage)

**Other:** Google Maps, Geolocator, Weather API, Image Picker, Shared Preferences

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 
- Firebase & Supabase accounts
- Google Maps API key

### Installation

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd onceinmind
   flutter pub get
   ```

2. **Firebase Setup**
   - Create Firebase project
   - Enable Authentication (Email/Password) and Firestore
   - Add config files:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

3. **Supabase Setup**
   - Create Supabase project
   - Create storage bucket named `journal-images`
   - Create `.env` file:
     ```env
     SUPABASE_URL=your_supabase_url
     SUPABASE_ANON_KEY=your_supabase_anon_key
     ```

4. **Google Maps Setup**
    - Get a Google Maps API key
    - For Android: Add to `android/app/src/main/AndroidManifest.xml`
    - For iOS: Add to `ios/Runner/AppDelegate.swift`

5. Run the app
   ```bash
   flutter run
   ```

## 📱 Screenshots
<img width="1000" height="480" alt="Adding Journal and lock it scenario" src="https://github.com/user-attachments/assets/33a1cc14-7312-4943-a801-4d7cd288d18f" />
<img width="1000" height="480" alt="Some other pages" src="https://github.com/user-attachments/assets/d60e2783-47f1-4a43-aa82-2e53fd7edff6" />

## 🔮 Future Enhancements

### Core Features
- [ ] Settings screen (theme, language, profile, change master password)
- [ ] Rich text formatting in journals
- [ ] Voice notes
- [ ] Reminders and notifications
- [ ] Social sharing options
- [ ] Add Google authentication

### AI-Powered Features
- [ ] **AI Weekly Summary**: Automatic weekly summaries highlighting key moments and patterns
- [ ] **Best Moments Detection**: AI identifies and surfaces your most memorable journal entries
- [ ] **Smart Journal Suggestions**: AI analyzes your entries to suggest journal topics and prompts
- [ ] **Enhanced Journal Creation**: AI-assisted journal creation with content suggestions and formatting
- [ ] **Sentiment Analysis**: Track emotional patterns and trends over time
- [ ] **Intelligent Insights**: AI-generated insights and reflections based on your journaling history

---

**Once in Mind** - Your personal space to express feelings and share memories with your future self.
