CREATE DATABASE RikkeiClinicDB;
USE RikkeiClinicDB;

-- PHẦN 1: KHỞI TẠO CẤU TRÚC BẢNG 

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

-- 2. Bảng Nhân sự / Bác sĩ (Employees)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

-- 3. Bảng Khoa (Departments)
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- 4. Bảng Giường bệnh (Beds)
CREATE TABLE Beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT DEFAULT NULL, -- NULL nghĩa là giường trống
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 5. Bảng Lịch khám (Appointments)
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Completed', 'Cancelled'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

-- 6. Bảng Kho Vật tư Y tế (Inventory)
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- 7. Bảng Kho Thuốc (Medicines)
CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 8. Bảng Công nợ Bệnh nhân (Patient_Invoices)
CREATE TABLE Patient_Invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 9. Bảng Sản phẩm (Products)
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 10. Bảng Dịch vụ khám (Services) 
CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

-- 11. Bảng Ví điện tử (Wallets) 
CREATE TABLE Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'Inactive'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 12. Bảng Lịch sử sử dụng dịch vụ (Service_Usages) 
CREATE TABLE Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- PHẦN 2: CHÈN DỮ LIỆU MẪU (TEST CASES)
-- Chèn Bệnh nhân
INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

-- Chèn Nhân sự 
INSERT INTO Employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

-- Chèn Khoa
INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Noi'),
(3, 'Khoa ICU');

-- Chèn Giường bệnh
INSERT INTO Beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1),    -- Bệnh nhân 1 đang nằm giường 101 Khoa Ngoại
(201, 2, NULL), -- Giường 201 Khoa Nội đang trống
(301, 3, 2);    -- Bệnh nhân 2 đang nằm ICU

-- Chèn Lịch khám 
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

-- Chèn Vật tư 
INSERT INTO Inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

-- Chèn Thuốc
INSERT INTO Medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100),  -- Tồn kho nhiều
(2, 'Panadol Extra', 5000, 5);         -- Tồn kho ít

-- Chèn Công nợ Bệnh nhân
INSERT INTO Patient_Invoices (patient_id, total_due) VALUES
(1, 1500000.00), -- Đã sửa: Nợ 1.5tr để test bài Giải phóng giường bệnh
(2, 0),
(3, 0);

-- Chèn Sản phẩm E-commerce 
INSERT INTO Products (name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20),
('May do duong huyet', 450000.00, 15);

-- Chèn Dịch vụ
INSERT INTO Services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

-- Chèn Ví điện tử
INSERT INTO Wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'),    -- Test Case 1: Đủ tiền thanh toán
(2, 50000.00, 'Active'),     -- Test Case 3: Cháy ví (Chỉ có 50k, không đủ khám 200k)
(3, 1000000.00, 'Inactive'); -- Test Case 2: Nhiều tiền nhưng thẻ bị khóa

delimiter //

create procedure processequipmentpurchase(
    in p_patient_id int, 
    in p_product_id int, 
    in p_quantity int,
    out p_message varchar(255)
)
begin
    declare v_stock int;
    declare v_price decimal(18,2);
    declare v_balance decimal(18,2);
    declare v_wallet_status varchar(20);
    declare v_total_cost decimal(18,2);
    declare v_error_flag int default 0;


    start transaction;

    select stock, price into v_stock, v_price 
    from products 
    where product_id = p_product_id for update;

    select balance, status into v_balance, v_wallet_status 
    from wallets 
    where patient_id = p_patient_id for update;

    if v_stock is null then
        set v_error_flag = 1;
        set p_message = 'thất bại: sản phẩm không tồn tại';
        
    elseif p_quantity > v_stock then
        set v_error_flag = 1;
        set p_message = 'thất bại: kho không đủ sản phẩm';
        
    elseif v_wallet_status is null then
        set v_error_flag = 1;
        set p_message = 'thất bại: ví không tồn tại';
        
    elseif v_wallet_status = 'inactive' then
        set v_error_flag = 1;
        set p_message = 'thất bại: ví đang bị khóa';
        
    else
        set v_total_cost = p_quantity * v_price;
        if v_balance < v_total_cost then
            set v_error_flag = 1;
            set p_message = 'thất bại: số dư ví không đủ';
        end if;
    end if;

    if v_error_flag = 1 then
        rollback;
    else
        update products set stock = stock - p_quantity where product_id = p_product_id;
        update wallets set balance = balance - v_total_cost where patient_id = p_patient_id;

        commit;
        set p_message = 'thành công: đã xử lý đơn hàng';
    end if;
end //

delimiter ;


set @ket_qua = '';

call processequipmentpurchase(1, 2, 1, @ket_qua);
select @ket_qua as '1: Hợp lệ';

call processequipmentpurchase(1, 1, 100, @ket_qua);
select @ket_qua as '2: Hết hàng';

call processequipmentpurchase(2, 1, 1, @ket_qua);
select @ket_qua as '3: Không đủ tiền';

call processequipmentpurchase(3, 1, 1, @ket_qua);
select @ket_qua as '4: Thẻ bị khóa';
