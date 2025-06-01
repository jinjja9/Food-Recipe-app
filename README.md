# Food Recipe App 🍳

## 1. Project Introduction

Food Recipe App is a modern recipe management application developed with Flutter and Firebase. This application helps users easily search, share, and manage their favorite recipes.

### 1.1 Objectives
- Create an easy-to-use recipe sharing platform
- Connect the community of cooking enthusiasts
- Provide efficient recipe management tools
- Create a user-friendly and intuitive experience

### 1.2 Target Users
- Home cooks
- Amateur and professional chefs
- Cooking enthusiasts
- People learning to cook
- Recipe sharers

## 2. Key Features 🌟

### 2.1 User Authentication
- Secure login and registration
- Social media authentication
- Password recovery
- User profile management

### 2.2 Recipe Management
- Create, read, update, and delete recipes
- Categorize recipes
- Upload recipe images
- Track cooking time and calories
- Step-by-step cooking instructions

### 2.3 User Experience
- Beautiful Material Design UI
- Easy navigation with bottom bar
- Interactive charts for recipe analytics
- Responsive design for all platforms

### 2.4 Social Features
- Comment on recipes
- Rate recipes
- Share recipes with others
- Follow other users

## 3. Technical Stack 🛠

### 3.1 Frontend
- **Framework**: Flutter SDK 3.5.4
- **State Management**: Flutter Bloc
- **UI Components**:
  - Material Design
  - Salomon Bottom Bar
  - FL Chart for data visualization
- **Image Handling**: Image Picker

### 3.2 Backend
- **Firebase Services**:
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage
  - Firebase Realtime Database

## 4. Supported Platforms 📱

- Android
- iOS
- Web
- Windows
- Linux
- macOS

## 5. System Architecture 🏗

### 5.1 Architecture Layers
1. **User Layer**: Direct user interaction through UI
2. **Client Layer**:
   - UI Components
   - State Management (BLoC)
   - Repository Layer
3. **Service Layer**:
   - Authentication Service
   - Recipe Service
   - User Service
   - Category Service
   - Notification Service
   - Analytics Service
4. **Firebase Layer**:
   - Authentication
   - Firestore
   - Storage
   - Realtime Database

## 6. Data Flow 🔄

### 6.1 Authentication Flow
- User registration/login
- System authentication
- User data storage
- Response to user

### 6.2 Recipe Management Flow
- Recipe creation/viewing
- Recipe data management
- Database operations
- User interface updates

### 6.3 Social Interaction Flow
- Comments and ratings
- Social data management
- Real-time updates
- User notifications

## 7. Getting Started 🚀

### 7.1 Prerequisites
- Flutter SDK 3.5.4 or higher
- Firebase account
- IDE (VS Code or Android Studio)

### 7.2 Installation
```bash
# Clone repository
git clone https://github.com/yourusername/food-recipe-app.git

# Navigate to project directory
cd food-recipe-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 7.3 Firebase Setup
- Create a new Firebase project
- Add your Firebase configuration
- Enable Authentication and Firestore
- Set up Storage rules

## 8. Database Schema 📊

### 8.1 Users
- User profiles
- Authentication data
- User preferences

### 8.2 Recipes
- Recipe details
- Ingredients
- Cooking steps
- Categories
- Ratings and comments

## 9. Demo App
Download and experience: [File APK](https://drive.google.com/drive/u/1/folders/1rGQXef4IX5vge6uhrQLHSnMbi03JZIh6)

Below are screenshots demonstrating the main features of the app (you can insert images here):

### 9.1 User Features
#### 9.1.1 Login
<table>
  <tr>
    <td><img src="assets\images\Ảnh chụp màn hình 2025-06-01 222137.png"width="200"/></td>
    <td><img src="assets\images\Ảnh chụp màn hình 2025-06-01 222437.png"width="200"/></td>
  </tr>
</table>

#### 9.1.2 Register
<table>
  <tr>
    <td><img src="assets\images\Ảnh chụp màn hình 2025-06-01 222609.png"
    width="200"/></td>
    <td><img src="assets\images\Ảnh chụp màn hình 2025-06-01 222618.png"
    width="200"/></td>
    <td><img src="assets\images\Ảnh chụp màn hình 2025-06-01 222623.png"
    width="200"/></td>
    <td><img src="assets\images\Ảnh chụp màn hình 2025-06-01 222629.png"
    width="200"/></td>
   </tr>
</table>

#### 9.1.3 Search recipes
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223140.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223126.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223202.png"
    width="200"/></td>

  <tr>  
</table>

#### 9.1.4 View recipe categories
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223140.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223727.png"
    width="207"/></td>
  <tr>   
</table>


#### 9.1.5 View popular recipes
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223918.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 223924.png"
    width="200"/></td>
  <tr>  
</table>

#### 9.1.6 View explore recipes
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224323.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224328.png"
    width="200"/></td>
  <tr>  
</table>


#### 9.1.7 View favorite recipes
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224334.png"
    width="200"/></td>
  <tr>  
</table>

#### 9.1.8 Add new recipe

<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224700.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224711.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224714.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224723.png"
    width="200"/></td>
  <tr> 
</table>

#### 9.1.9 Edit recipe
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 224959.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225003.png"
    width="200"/></td>
  <tr>  
</table>

#### 9.1.10 Delete recipe
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225009.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225016.png"
    width="200"/></td>
  <tr>  
</table>


#### 9.1.11 Save recipes
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225311.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225316.png"
    width="200"/></td>
  <tr>  
</table>

#### 9.1.12 View personal information
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225359.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225404.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225408.png"
    width="200"/></td>
  <tr>  
</table>

#### 9.1.13 Edit personal information
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225534.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225552.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225556.png"
    width="200"/></td>
  <tr>  
</table>

### 9.2 Admin Features
#### 9.2.1 Manage user information
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225752.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225805.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225809.png"
    width="200"/></td>
  <tr>  
</table>

#### 9.2.2 Manage system recipes
<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225931.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225936.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 225939.png"
    width="200"/></td>
  <tr>  
</table>


#### 9.2.3 Manage categories

<table>
  <tr>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 230044.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 230052.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 230055.png"
    width="200"/></td>
    <td><img src="assets\images\Search recipes\Ảnh chụp màn hình 2025-06-01 230059.png"
    width="200"/></td>
  <tr>  
</table>


## 10. Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## 11. License 📝

This project is licensed under the MIT License - see the LICENSE file for details.

## 12. Authors 👥

- Your Name - Initial work

## 13. Acknowledgments 🙏

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors who have helped shape this project
