# BODIMA

> **Find Your Place. Feel at Home.**

BODIMA is a smart boarding-finder platform designed to help university students in Sri Lanka discover, explore, and compare suitable boarding places. It also aims to provide boarding owners with a convenient platform to publish and manage their property listings.

Our goal is to make finding student accommodation easier, faster, and more reliable through a centralized digital platform.

---

## 📌 Project Overview

Finding suitable accommodation is one of the major challenges faced by university students, especially those who move to a new city for higher education.

Currently, students often depend on social media posts, personal contacts, and scattered online advertisements to find boarding places. This makes it difficult to compare prices, facilities, locations, and other important details.

**BODIMA aims to solve this problem** by providing a centralized platform where students can discover boarding places based on their preferences, budget, and location.

The platform will also help boarding owners manage their listings and connect with potential tenants.

## 🎯 Project Objectives

- Simplify the boarding-search process for university students.
- Provide organized and accessible boarding information.
- Allow students to compare accommodation options.
- Support location-based boarding discovery.
- Improve trust through a planned listing verification process.
- Help boarding owners manage their property listings.
- Build a user-friendly and reliable accommodation platform.

## ✨ Planned Features

### 🎓 Student Features

- Browse available boarding places.
- Search boarding places by location.
- Filter listings by price, room type, and facilities.
- View detailed boarding information and photographs.
- Explore boarding locations using an interactive map.
- Save favourite boarding places.
- Manage personal profiles.
- Contact boarding owners.
- Report suspicious or inaccurate listings.

### 🏠 Boarding Owner Features

- Register and manage owner accounts.
- Create and publish boarding listings.
- Upload property photographs.
- Update boarding information and availability.
- Manage existing listings.
- Receive and manage student enquiries.

### 🛡️ Admin Features

- Manage student and owner accounts.
- Review and manage boarding listings.
- Handle listing verification requests.
- Manage reported listings.
- Monitor platform activities.

> **Note:** The features listed above represent the planned functionality. They are not all implemented yet.

## 👥 Target Users

| User Type | Description |
|---|---|
| University Students | Students searching for suitable accommodation |
| Boarding Owners | Property owners who want to publish boarding listings |
| Administrators | Platform administrators responsible for management and moderation |

## 🛠️ Technology Stack

The following technologies are planned for the development of BODIMA.

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application |
| Dart | Application programming language |
| Material 3 | UI design system |
| Riverpod | State management |
| GoRouter | Application navigation |
| Supabase | Backend services |
| PostgreSQL | Relational database |
| PostGIS | Location-based database queries |
| Supabase Auth | User authentication |
| Supabase Storage | Image and file storage |
| Flutter Map | Map integration |
| OpenStreetMap | Map data |
| Next.js | Planned admin dashboard |
| Git & GitHub | Version control and collaboration |

## 🏗️ Project Architecture

BODIMA is planned to follow a feature-first architecture to improve code organization, maintainability, and scalability.

### Initial Flutter Project Structure

```text
BODIMA/
│
├── android/
├── ios/
├── web/
│
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
│
├── lib/
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── router/
│   │   ├── theme/
│   │   └── utils/
│   │
│   ├── shared/
│   │   └── widgets/
│   │
│   ├── features/
│   │   ├── authentication/
│   │   ├── home/
│   │   ├── explore/
│   │   ├── boarding_details/
│   │   ├── favorites/
│   │   ├── profile/
│   │   └── owner/
│   │
│   ├── services/
│   │
│   └── main.dart/
│
├── test/
│
├── pubspec.yaml
└── README.md
```

*The actual structure may evolve during implementation.*

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Dart SDK
- Git
- Android Studio or Visual Studio Code
- Android Emulator or a physical Android device

### 1. Clone the Repository

```bash
git clone https://github.com/wishmitha2003/BODIMA.git
```

### 2. Navigate to the Project

```bash
cd BODIMA
```

### 3. Install Dependencies

Once the Flutter project scaffold is available:

```bash
flutter pub get
```

### 4. Run the Application

```bash
flutter run
```

### 5. Run Code Analysis and Tests

```bash
flutter analyze
flutter test
```

**Note:** The repository is currently in its initial setup stage. Flutter application commands require the Flutter project scaffold to be added.

## 🎨 UI/UX Design Direction

BODIMA follows a modern, clean, and professional design approach.

### Visual Identity

- **Primary Colors:** Navy Blue and Teal.
- **Design System:** Material 3.
- **Appearance:** Light Mode and Dark Mode.
- **Typography:** Inter and Noto Sans Sinhala.
- **Spacing:** Consistent 8-point spacing system.
- **Design Priorities:** Simplicity, accessibility, usability, and trust.

## 📍 Development Roadmap

The development will follow these planned phases:

- [ ] Initial project setup and configuration
- [ ] Establish design system and theme
- [ ] Develop reusable UI components
- [ ] Design and implement Home Screen
- [ ] Implement boarding search and filtering
- [ ] Develop boarding details screen
- [ ] Integrate map and location services
- [ ] Implement user authentication
- [ ] Develop student profile management
- [ ] Implement boarding owner dashboard
- [ ] Integrate Supabase backend
- [ ] Implement listing verification
- [ ] Develop administration dashboard
- [ ] Perform testing and optimization
- [ ] Prepare for deployment

## 🔐 Security

Security and user privacy are important considerations in BODIMA.

- Sensitive credentials must not be committed to the repository.
- Environment variables should be used for private configuration.
- Database access should be protected using appropriate access policies.
- User authentication and authorization should be implemented securely.
- User information should be handled responsibly.

## 🤝 Contributing

Contributions and suggestions are welcome as the project develops.

If you would like to contribute:

1. Fork the repository.
2. Create a new feature branch.
3. Implement your changes.
4. Test your changes.
5. Commit your changes with a meaningful commit message.
6. Create a Pull Request.

Example:

```bash
git checkout -b feature/your-feature-name
git add .
git commit -m "feat: add your feature"
git push origin feature/your-feature-name
```

## 📄 License

A license has not yet been selected for this project. All rights are reserved by default unless a license is added.

---

## 🌟 Project Vision

**BODIMA – Find Your Place. Feel at Home.**

Our vision is to make finding student accommodation in Sri Lanka a simpler, smarter, and more trustworthy experience.

**Built with ❤️ for Sri Lankan university students.**
