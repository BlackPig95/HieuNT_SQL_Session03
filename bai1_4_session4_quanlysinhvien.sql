-- Bước 1: Tạo CSDL QuanLySinhVien
CREATE DATABASE QuanLySinhVien;
-- Bước 2: Chọn Database QuanLySinhVien để thao tác với cơ sở dữ liệu này:
USE QuanLySinhVien;
-- Bước 3: Tiếp theo sử dụng câu lệnh Create Table để tạo bảng Class với các trường ClassId, ClassName, StartDate, Status như sau:
CREATE TABLE Class
(
    ClassID   INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME    NOT NULL,
    Status    BIT
);
-- Bước 4: Tạo bảng Student với các thuộc tính StudentId, StudentName, Address, Phone, Status, ClassId với rằng buộc như sau:
CREATE TABLE Student
(
    StudentId   INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address     VARCHAR(50),
    Phone       VARCHAR(20),
    Status      BIT,
    ClassId     INT         NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
-- Bước 5: Tạo bảng Subject với các thuộc tính SubId, SubName, Credit, Status với các ràng buộc như sau :
CREATE TABLE Subject
(
    SubId   INT AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit  TINYINT     NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
    Status  BIT                  DEFAULT 1
);
-- Bước 6: Tạo bảng Mark với các thuộc tính MarkId, SubId, StudentId, Mark, ExamTimes với các ràng buộc như sau :
CREATE TABLE Mark
(
    MarkId    INT AUTO_INCREMENT PRIMARY KEY,
    SubId     INT NOT NULL,
    StudentId INT NOT NULL,
    Mark      FLOAT   DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);
insert into Class (ClassName, StartDate, Status)
VALUES ('Lớp 1', now(), 1),
       ('Lớp 2', '2024-12-29 12:0:1', 1),
       ('Lớp 3', '2023-12-23 12:0:1', 0),
       ('Lớp 4', '2022-1-1', 1);
insert into Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Nguyễn Văn A', 'Địa chỉ 1', 'SĐT1', 1, 1),
       ('Hoàng Thị B', 'Địa chỉ 2', 'SĐT2', 0, 2),
       ('Lưu Văn C', 'Địa chỉ 3', 'SĐT3', 1, 1),
       ('Học sinh 4', 'Địa chỉ 4', 'SĐT4', 1, 3);
insert into Subject (SubName, Credit, Status)
VALUES ('Physics', 67, 1),
       ('Math', 74, 1),
       ('Biology', 85, 1),
       ('Literature', 50, 0),
       ('IT', 91, 1);
insert into Mark (SubId, StudentId, Mark, ExamTimes)
VALUES (1, 1, 85, 20),
       (2, 1, 45, 41),
       (5, 3, 55, 50),
       (3, 2, 15, 30),
       (1, 4, 90, 23),
       (2, 4, 35, 35),
       (4, 3, 70, 46),
       (3, 1, 64, 31),
       (5, 2, 83, 24);
insert into Mark (SubId, StudentId, Mark, ExamTimes)
VALUES (5, 1, 100, 30);

# o	Hiển thị số lượng sinh viên theo từng địa chỉ nơi ở.
select count(s.StudentId)
from student s
group by s.Address;
# o	Hiển thị các thông tin môn học có điểm thi lớn nhất.
select *
from Subject s
         join Mark m on s.SubId = m.SubId
where m.Mark >= ALL (select mark from mark);
select s.*
from Subject s
         join Mark m on s.SubId = m.SubId
where m.Mark >= ALL (select mark from mark);
select s.*, max(m.Mark)
from Subject s
         join Mark m on s.SubId = m.SubId
group by s.SubId, m.Mark
order by m.Mark desc
limit 1;
# o	Tính điểm trung bình các môn học của từng học sinh.
select s.StudentName, avg(m.Mark)
from Student s
         join Mark M on s.StudentId = M.StudentId
group by s.StudentId;
# o	Hiển thị những bạn học viên có điểm trung bình các môn học nhỏ hơn bằng 70.
select s.StudentName, avg(m.Mark)
from Student s
         join Mark M on s.StudentId = M.StudentId
group by s.StudentId
having avg(m.Mark) <= 70;
# o	Hiển thị thông tin học viên có điểm trung bình các môn lớn nhất.
select s.*, avg(m.Mark) as average
from Student s
         join Mark M on s.StudentId = M.StudentId
group by s.StudentId
having average >= ALL (select avg(Mark) from Mark group by mark.StudentId);
# o	Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên,
# xếp hạng theo thứ tự điểm giảm dần
select s.*, avg(m.Mark) as average
from Student s
         join Mark M on s.StudentId = M.StudentId
group by s.StudentId
order by average desc;
# 	Hiển thị tất cả học sinh thuộc lớp A1
select s.StudentName
from Student s
         join Class C
              on s.ClassId = C.ClassID
where c.ClassName = 'Lớp 1';
# 	Hiển thị tất cả học sinh thi môn “Toán”
select s.StudentName
from Student s
         join Mark M
              on s.StudentId = M.StudentId
         join Subject Sub on M.SubId = Sub.SubId
where sub.SubName = 'Math';
# 	Hiển thị tất cả học sinh có điểm trung bình lớn hơn 5
select s.StudentName, avg(m.Mark) from Student s join Mark M on s.StudentId = M.StudentId
                     group by s.StudentName
having avg(m.Mark) > 50;
# 	Hiển thị các môn học có điểm trung bình dưới 5
select s.SubName from Subject s join Mark M on s.SubId = M.SubId
group by m.SubId having avg(m.Mark) < 50;
# 	Hiển thị tất cả học sinh không thi môn nào
select s.StudentId, s.StudentName from Student s join Mark M on s.StudentId = M.StudentId
where not exists(select mark.StudentId from mark);