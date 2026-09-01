# Facebook Replica (Flutter)

A Flutter-based Facebook replica application demonstrating core social media features, REST API integration, and local session management.

---

## 🏛️ Architecture & Interaction (Models $\rightarrow$ Services $\rightarrow$ Screens)

The project follows a **Layered Architecture** with a clear separation of concerns across three core layers:

```
[ Screens / UI ]  ◄──(Displays Data / Listens to User Events)──►  [ Services ]  ◄──(Serializes / Deserializes)──►  [ Models ]
```

### 1. Models (`lib/models/`)
- **Role**: Blueprint for application data (`User`, `Post`, `Comment`).
- **Function**: Converts raw JSON from API responses into strongly-typed Dart objects using `.fromJson()`, and maps Dart objects back into JSON using `.toJson()`.
- **Interaction**: Consumed by Services to return structured objects instead of raw dynamic maps.

### 2. Services (`lib/services/`)
- **Role**: Data access, business logic, and API/storage handling (`UserService`, `PostService`, `CommentService`).
- **Function**: Executes HTTP requests (`GET`/`POST`) to REST endpoints and manages local storage via `SharedPreferences`.
- **Interaction**: Calls `Model.fromJson()` to parse API responses, returning typed `Future<User>`, `Future<List<Post>>`, etc., to the requesting Screens.

### 3. Screens (`lib/screens/`)
- **Role**: Presentation and UI state management (`LogInScreen`, `NewsFeedScreen`, `DetailScreen`, `ProfileScreen`).
- **Function**: Displays data in widgets (`PostCard`, dialogs, text fields) and listens to user input (tapping buttons, posting comments, pull-to-refresh).
- **Interaction**: Triggers Service methods asynchronously, handles loading states, and binds the returned Model data to Flutter widgets using `setState()`.

---

### 🔄 Example Flow (Newsfeed)
1. **Screen** (`NewsFeedScreen`): Initiates `PostService.getPosts()` on load.
2. **Service** (`PostService`): Fetches JSON from the REST API endpoint and maps each item into a `Post` model via `Post.fromJson()`.
3. **Model** (`Post`): Parses fields (e.g. `body`, `likes`, `userId`) safely with type checks.
4. **Service $\rightarrow$ Screen**: Returns `List<Post>` to the screen, which calls `setState()` and renders `PostCard` widgets.

---

---

## Discussion
Discussion - The app follows a strict Model → Service → Screen flow. Models (post.dart, user.dart, comment.dart) define typed Dart objects via fromJson(), with no knowledge of networking or UI. Services (post_service.dart, user_service.dart, comment_service.dart) handle all HTTP communication with dummyjson.com, parsing JSON responses into Model instances and returning them as Futures; they also manage side effects like saving session data via shared_preferences. Screens (splash_screen.dart, profile_screen.dart, settings_screen.dart) never call the API directly — they use FutureBuilder to invoke Service methods on initState() or user actions, showing a loading indicator until the typed data resolves and can be rendered. This one-way flow keeps each layer decoupled: Models don't know about HTTP, Services don't know about widgets, and Screens don't know about raw JSON.

## 🔗 Public Repository Link

- **GitHub Repository**: [https://github.com/IvanEzkl/fb-replica](https://github.com/IvanEzkl/fb-replica)
