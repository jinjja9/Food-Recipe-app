# Food-Recipe-app

## I. Thiết kế CSDL
### 1.  System Architecture Diagram(Kiến trúc tổng thể hệ thống)

#### 1. Lớp người dùng (User Layer)
#### 2. Lớp Client (Client Layer)

`Client Layer` là lớp phía người dùng trong kiến trúc phần mềm, nơi thực hiện các tương tác trực tiếp với người dùng thông qua giao diện UI, và xử lý logic quản lý trạng thái thông qua các mô hình như BLoC hoặc Provider.

- **UI Components**: Các thành phần giao diện người dùng như màn hình, widget, và các thành phần tương tác.

- **BLoC/Provider (State Management)**: Lớp quản lý trạng thái ứng dụng, sử dụng mô hình BLoC (Business Logic Component) hoặc Provider để tách biệt logic nghiệp vụ khỏi UI.

- **Repository Layer**: Lớp trung gian đóng vai trò cầu nối giữa UI và các dịch vụ, cung cấp API đồng nhất cho tầng UI và xử lý logic nghiệp vụ.

#### 3. Lớp dịch vụ (Service Layer)

Đóng vai trò là cầu nối giữa lớp `Repository` và các dịch vụ bên ngoài (như `Firebase`). Nó chứa logic nghiệp vụ cụ thể và xử lý giao tiếp với các API bên ngoài.

- **Authentication Service**: Xử lý tất cả các hoạt động liên quan đến xác thực như đăng nhập, đăng ký, quên mật khẩu.
- **Recipe Service**: Quản lý tất cả các hoạt động liên quan đến công thức nấu ăn như tạo, đọc, cập nhật, xóa.
- **User Service**: Quản lý thông tin người dùng, hồ sơ, và các tương tác giữa người dùng.
- **Category Service**: Quản lý các danh mục công thức.
- **Notification Service**: Xử lý việc gửi và nhận thông báo.
- **Analytics Service**: Thu thập và xử lý dữ liệu phân tích về hành vi người dùng.

#### 4. Lớp Firebase (Firebase Services)

- **Firebase Authentication**: Dịch vụ xác thực của Firebase, quản lý đăng nhập/đăng ký người dùng.

- **Firebase Firestore**: , cho phép bạn lưu trữ và truy xuất dữ liệu theo dạng tài liệu (documents) trong các bộ sưu tập (collections). Dùng để lưu comment, công thức nấu ăn

- **Firebase Storage**: Dịch vụ lưu trữ của Firebase, dùng để lưu hình ảnh và video.

- **Firebase Realtime Database**

### 2. Data Flow Diagram

**Luồng dữ liệu chính:**

**1. Xác thực**: Người dùng đăng ký/đăng nhập → Hệ thống xác thực → Lưu thông tin vào DB_Users → Trả kết quả cho người dùng.

**2. Quản lý công thức**: Người dùng thêm/xem công thức → Quản lý công thức → Lưu/lấy dữ liệu từ DB_Recipes → Hiển thị cho người dùng.

**3. Bình luận & Đánh giá**: Người dùng bình luận/đánh giá → Quản lý bình luận & đánh giá → Lưu vào DB_Comments/DB_Ratings → Hiển thị cho người dùng.

**4. Quản lý người dùng**: Admin quản lý người dùng → Quản lý người dùng → Cập nhật/lấy dữ liệu từ DB_Users → Hiển thị cho admin.

**5. Quản lý danh mục**: Admin quản lý danh mục → Quản lý danh mục → Cập nhật/lấy dữ liệu từ DB_Categories → Hiển thị cho admin.


## I. Nhóm quản lý người dùng và phân quyền (ERD)
### 1. Bảng `roles` (Vai trò)

- **Mục đích**: Định nghĩa các vai trò trong hệ thống
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `name`: Tên vai trò (admin, user), không được trùng lặp
- `description`: Mô tả chi tiết về vai trò
- `created_at`: Thời điểm tạo vai trò



### 2. Bảng `users` (Người dùng)

- **Mục đích**: Lưu trữ thông tin đăng nhập và trạng thái của người dùng
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `username`: Tên đăng nhập, không được trùng lặp
- `email`: Email, không được trùng lặp
- `password`: Mật khẩu (đã mã hóa)
- `role_id`: Khóa ngoại liên kết với bảng `roles`, xác định vai trò của người dùng
- `status`: Trạng thái tài khoản (active, inactive)
- `join_date`: Ngày tham gia
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật





### 3. Bảng `user_profiles` (Thông tin cá nhân)

- **Mục đích**: Lưu trữ thông tin chi tiết về người dùng
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `user_id`: Khóa ngoại liên kết với bảng `users` (quan hệ 1-1)
- `full_name`: Họ và tên đầy đủ
- `avatar_image`: Đường dẫn đến ảnh đại diện
- `bio`: Tiểu sử/giới thiệu
- `phone`: Số điện thoại
- `address`: Địa chỉ
- `date_of_birth`: Ngày sinh
- `gender`: Giới tính
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật



## II. Nhóm quản lý công thức và nội dung

### 6. Bảng `categories` (Danh mục)

- **Mục đích**: Phân loại các công thức nấu ăn
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `name`: Tên danh mục
- `description`: Mô tả về danh mục
- `color`: Mã màu đại diện cho danh mục
- `recipe_count`: Số lượng công thức trong danh mục
- `created_by`: Khóa ngoại liên kết với bảng `users`, người tạo danh mục (admin)
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật





### 7. Bảng `recipes` (Công thức)

- **Mục đích**: Lưu trữ thông tin chính về công thức nấu ăn
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `name`: Tên công thức
- `description`: Mô tả về công thức
- `image`: Đường dẫn đến hình ảnh món ăn
- `calories`: Lượng calo
- `cooking_time`: Thời gian nấu (phút)
- `user_id`: Khóa ngoại liên kết với bảng `users`, người tạo công thức
- `category_id`: Khóa ngoại liên kết với bảng `categories`, danh mục của công thức
- `status`: Trạng thái công thức (draft, published, archived)
- `view_count`: Số lượt xem
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật



### 9. Bảng `steps` (Bước thực hiện)

- **Mục đích**: Lưu trữ các bước thực hiện công thức
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `recipe_id`: Khóa ngoại liên kết với bảng `recipes`
- `description`: Mô tả bước thực hiện
- `image`: Đường dẫn đến hình ảnh minh họa cho bước
- `order_index`: Thứ tự bước
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật



## III. Nhóm tương tác xã hội

### 10. Bảng `ratings` (Đánh giá)

- **Mục đích**: Lưu trữ đánh giá của người dùng về công thức
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `recipe_id`: Khóa ngoại liên kết với bảng `recipes`
- `user_id`: Khóa ngoại liên kết với bảng `users`
- `rating`: Điểm đánh giá (1-5 sao)
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật
- Có ràng buộc unique cho cặp (recipe_id, user_id)





### 11. Bảng `comments` (Bình luận)

- **Mục đích**: Lưu trữ bình luận của người dùng về công thức
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `recipe_id`: Khóa ngoại liên kết với bảng `recipes`
- `user_id`: Khóa ngoại liên kết với bảng `users`
- `parent_id`: Khóa ngoại tự tham chiếu đến bảng `comments`, cho phép trả lời bình luận
- `content`: Nội dung bình luận
- `likes`: Số lượt thích bình luận
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật





### 12. Bảng `favorites` (Yêu thích)

- **Mục đích**: Lưu trữ công thức yêu thích của người dùng
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `recipe_id`: Khóa ngoại liên kết với bảng `recipes`
- `user_id`: Khóa ngoại liên kết với bảng `users`
- `created_at`: Thời điểm yêu thích
- Có ràng buộc unique cho cặp (recipe_id, user_id)





### 13. Bảng `follows` (Theo dõi)

- **Mục đích**: Lưu trữ mối quan hệ theo dõi giữa người dùng
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `follower_id`: Khóa ngoại liên kết với bảng `users`, người theo dõi
- `following_id`: Khóa ngoại liên kết với bảng `users`, người được theo dõi
- `created_at`: Thời điểm theo dõi
- Có ràng buộc unique cho cặp (follower_id, following_id)





### 14. Bảng `user_favorite_foods` (Món ăn ưa thích)

- **Mục đích**: Lưu trữ các món ăn ưa thích của người dùng (không nhất thiết là công thức trong hệ thống)
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `user_id`: Khóa ngoại liên kết với bảng `users`
- `food_name`: Tên món ăn ưa thích
- `description`: Mô tả về món ăn
- `created_at`, `updated_at`: Thời điểm tạo và cập nhật





## IV. Nhóm thông báo và quản trị

### 15. Bảng `notifications` (Thông báo)

- **Mục đích**: Lưu trữ thông báo cho người dùng
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `user_id`: Khóa ngoại liên kết với bảng `users`, người nhận thông báo
- `sender_id`: Khóa ngoại liên kết với bảng `users`, người gửi thông báo
- `type`: Loại thông báo (like, comment, follow, rating)
- `content`: Nội dung thông báo
- `recipe_id`: Khóa ngoại liên kết với bảng `recipes`, công thức liên quan (nếu có)
- `comment_id`: Khóa ngoại liên kết với bảng `comments`, bình luận liên quan (nếu có)
- `is_read`: Trạng thái đã đọc
- `created_at`: Thời điểm tạo thông báo





### 16. Bảng `admin_activity_logs` (Nhật ký hoạt động của Admin)

- **Mục đích**: Ghi lại các hoạt động của admin trong hệ thống
- **Các trường chính**:

- `id`: Khóa chính, tự động tăng
- `admin_id`: Khóa ngoại liên kết với bảng `users`, admin thực hiện hành động
- `action`: Loại hành động (create, update, delete, block_user...)
- `entity_type`: Loại đối tượng bị tác động (user, recipe, category...)
- `entity_id`: ID của đối tượng bị tác động
- `details`: Chi tiết hành động
- `created_at`: Thời điểm thực hiện hành động





## Mối quan hệ chính trong sơ đồ:

1. **User - Role**: Mỗi người dùng có một vai trò (1-n)
2. **User - User Profile**: Mỗi người dùng có một hồ sơ cá nhân (1-1)
3. **Role - Permission**: Mỗi vai trò có nhiều quyền hạn (n-n thông qua bảng role_permissions)
4. **User - Recipe**: Mỗi người dùng có thể tạo nhiều công thức (1-n)
5. **Category - Recipe**: Mỗi danh mục chứa nhiều công thức (1-n)
6. **Recipe - Ingredient**: Mỗi công thức có nhiều nguyên liệu (1-n)
7. **Recipe - Step**: Mỗi công thức có nhiều bước thực hiện (1-n)
8. **User - Rating - Recipe**: Người dùng đánh giá công thức (n-n)
9. **User - Comment - Recipe**: Người dùng bình luận về công thức (n-n)
10. **User - Favorite - Recipe**: Người dùng yêu thích công thức (n-n)
11. **User - Follow - User**: Người dùng theo dõi người dùng khác (self-referencing n-n)
12. **User - User Favorite Foods**: Người dùng có nhiều món ăn ưa thích (1-n)
13. **User - Notification**: Người dùng nhận nhiều thông báo (1-n)
14. **Admin - Admin Activity Log**: Admin có nhiều hoạt động được ghi lại (1-n)