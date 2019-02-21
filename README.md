# bulk_users_in_active_directory
Create Bulk Users in Active Directory in Powershell

Để tạo tài khoản người dùng trong hệ thống Active Directory của Windows Server, ta có thể sử dụng giao diện đồ họa và nhấp chuột, điền vào từng mục để hoàn tất. Nhưng với số lượng tài khoản lớn lên tới hàng trăm, hàng nghìn người dùng, ta không thể ngồi làm tay cho tất cả được.

Giải pháp hoàn hảo cho tình huống này không gì khác hơn là sử dụng môi trường dòng lệnh, cụ thể là Powershell.

Nếu đã từng lập trình qua thì việc sử dụng Powershell cũng không có gì khó khăn. Để làm được việc này, ta cần chuẩn bị 2 file:

- File CSV để lưu trữ toàn bộ các record dữ liệu về người dùng.
