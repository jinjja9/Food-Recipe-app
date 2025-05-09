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



### 9. Bảng `steps`