CREATE DATABASE KhachSan 
GO

USE KhachSan  
GO

-- 1. Tạo bảng "Tài khoản"
CREATE TABLE TaiKhoan 
(
	MaTaiKhoan INT PRIMARY KEY,
	TenDangNhap VARCHAR(50) NOT NULL,
	MatKhau VARCHAR(50) NOT NULL 
)
GO 

-- 2. Tạo bảng "Khách"
CREATE TABLE Khach 
(
	MaKhach CHAR(10) PRIMARY KEY,
	HoTen NVARCHAR(100) NOT NULL,
	Email VARCHAR(50),
	SDT VARCHAR(10) NOT NULL,
	MaTaiKhoan INT FOREIGN KEY REFERENCES TaiKhoan(MaTaiKhoan)
)
GO 

-- 3. Tạo bảng "Khách lưu trú"
CREATE TABLE KhachLuuTru 
(
    MaKhachLuuTru CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    CCCD VARCHAR(20) UNIQUE,
    SDT VARCHAR(10) NOT NULL
)
GO 

-- 4. Tạo bảng "Nhân viên"
CREATE TABLE NhanVien 
(
    MaNhanVien CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email VARCHAR(50),
    SDT VARCHAR(10) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    DiaChi NVARCHAR(50),
    ChucVu NVARCHAR(20),
    MaTaiKhoan INT FOREIGN KEY REFERENCES TaiKhoan(MaTaiKhoan)
)
GO 

-- 5. Tạo bảng "Loại phòng"
CREATE TABLE LoaiPhong 
(
    MaLoaiPhong CHAR(10) PRIMARY KEY,
    TenLoaiPhong NVARCHAR(20) NOT NULL,
    GiaCoBan MONEY NOT NULL CHECK (GiaCoBan > 0),
    SoNguoiToiDa INT NOT NULL
)
GO 


-- 6. Tạo bảng "Phòng"
CREATE TABLE Phong 
(
    MaPhong CHAR(10) PRIMARY KEY,
    SoPhong INT NOT NULL,
    Tang INT,
    MoTa NVARCHAR(200),
    SoGiuong INT CHECK (SoGiuong > 0),
    TrangThaiPhong NVARCHAR(20) CHECK (TrangThaiPhong IN (N'Sẵn sàng', N'Đang ở', N'Đang dọn dẹp', N'Bảo trì', N'Ngưng sử dụng')),
    MaLoaiPhong CHAR(10) FOREIGN KEY REFERENCES LoaiPhong(MaLoaiPhong)
)
GO 

-- 7. Tạo bảng "Lịch đặt phòng"
CREATE TABLE LichDatPhong (
    MaLich CHAR(10) PRIMARY KEY, 
    ThoiGianBatDau DATETIME NOT NULL, 
    ThoiGianKetThuc DATETIME NOT NULL, 
    TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Đã Đặt', N'Đã Hủy')), 
    MaPhong CHAR(10) FOREIGN KEY REFERENCES Phong(MaPhong)
)
GO 


-- 8. Tạo bảng "Dịch vụ"
CREATE TABLE DichVu 
(
    MaDichVu CHAR(10) PRIMARY KEY,
    TenDichVu NVARCHAR(20) NOT NULL,
    Gia MONEY CHECK (Gia > 0)
)
GO 

-- 9. Tạo bảng "Phiếu đánh giá"
CREATE TABLE PhieuDanhGia 
(
    MaPhieu CHAR(10) PRIMARY KEY,
    NhanXet NVARCHAR(200),
    Diem INT CHECK (Diem BETWEEN 1 AND 5),
    MaPhong CHAR(10)  FOREIGN KEY REFERENCES Phong(MaPhong),
    MaKhach CHAR(10) FOREIGN KEY REFERENCES Khach(MaKhach)
) 
GO 

-- 10. Tạo bảng "Danh Mục Cơ sở vật chất"
CREATE TABLE DanhMucCSVC 
(
    MaDanhMuc CHAR(10) PRIMARY KEY,
    Ten NVARCHAR(20) NOT NULL,
    MoTa NVARCHAR(50)
) 
GO 

-- 11. Tạo bảng "Cơ sở vật chất"
CREATE TABLE CoSoVatChat 
(
    MaCSVC CHAR(10) PRIMARY KEY, 
    Ten NVARCHAR(20) NOT NULL, 
    ViTri NVARCHAR(20), 
    NgayMua DATE, 
    TinhTrang NVARCHAR(20) CHECK (TinhTrang IN (N'Tốt', N'Trung bình', N'Kém')), 
    TrangThaiSuDung NVARCHAR(20) CHECK (TrangThaiSuDung IN (N'Đang Sử Dụng', N'Ngưng Sử Dụng', N'Đang Bảo Trì')), 
    MaDanhMuc CHAR(10) FOREIGN KEY REFERENCES DanhMucCSVC(MaDanhMuc),
    MaPhong CHAR(10) FOREIGN KEY REFERENCES Phong(MaPhong)
)
GO 

-- 12. Tạo bảng "Thẻ điểm"
CREATE TABLE TheDiem 
(
    MaThe CHAR(10) PRIMARY KEY,
    SoDiemHienTai INT CHECK (SoDiemHienTai >= 0),
    SoDiemDaSuDung INT CHECK (SoDiemDaSuDung >= 0),
    MaKhach CHAR(10) FOREIGN KEY REFERENCES Khach(MaKhach)
)
GO 

-- 13. Tạo bảng "Ưu đãi"
CREATE TABLE UuDai 
(
    MaUuDai CHAR(10) PRIMARY KEY,
    TenUuDai NVARCHAR(20) NOT NULL,
    MoTa NVARCHAR(100),
    SoDiemCanDoi INT CHECK (SoDiemCanDoi > 0),
    NgayHetHan DATE NOT NULL
)
GO 

-- 14. Tạo bảng "Đơn đặt phòng"
CREATE TABLE DonDatPhong 
(
    MaDonDatPhong CHAR(10) PRIMARY KEY,
    NgayCheckIn DATE NOT NULL,
    NgayCheckOut DATE NOT NULL,
    TongTien MONEY CHECK (TongTien > 0),
    GiamGia MONEY CHECK (GiamGia >= 0),
    ThanhTien MONEY CHECK (ThanhTien >= 0),
    MaKhach CHAR(10) FOREIGN KEY REFERENCES Khach(MaKhach),
    CHECK (NgayCheckOut > NgayCheckIn)
)
GO 

-- 15. Tạo bảng "Chi tiết đơn đặt phòng"
CREATE TABLE ChiTietDatPhong (
    MaPhong CHAR(10),
    MaDonDatPhong CHAR(10),
    DonGia MONEY,
    PRIMARY KEY (MaPhong, MaDonDatPhong),
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong),
    FOREIGN KEY (MaDonDatPhong) REFERENCES DonDatPhong(MaDonDatPhong)
)
GO 

-- 16. Tạo bảng "Đơn đặt dịch vụ"
CREATE TABLE DonDatDichVu 
(
    MaDonDichVu CHAR(10) PRIMARY KEY,
    NgayDat DATETIME,
    TongTien MONEY CHECK (TongTien > 0),
    GiamGia MONEY CHECK (GiamGia >= 0),
    ThanhTien MONEY CHECK (ThanhTien >= 0),
    MaKhachLuuTru CHAR(10) FOREIGN KEY REFERENCES KhachLuuTru(MaKhachLuuTru)
)
GO 

-- 17. Tạo bảng "Chi tiết đơn đặt dịch vụ"
CREATE TABLE ChiTietDonDatDV (
    SoLuong INT CHECK (SoLuong > 0),
    DonGia MONEY,
    MaDichVu CHAR(10),
    MaDonDatDichVu CHAR(10),
    PRIMARY KEY (MaDichVu, MaDonDatDichVu),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu),
    FOREIGN KEY (MaDonDatDichVu) REFERENCES DonDatDichVu(MaDonDichVu)
)
GO 

-- 18. Tạo bảng "Hóa đơn"
CREATE TABLE HoaDon (
    MaHoaDon CHAR(10) PRIMARY KEY,
    SoHoaDon VARCHAR(20) UNIQUE,
    LoaiHoaDon VARCHAR(10) CHECK (LoaiHoaDon IN (N'Đỏ', N'Thường')), 
    TenCongTy VARCHAR(50), 
    NgayLap DATETIME NOT NULL,
    TongTien MONEY CHECK (TongTien > 0),
    TienPhong MONEY CHECK (TienPhong > 0),
    TienDichVu MONEY CHECK (TienDichVu > 0),
    ThueVAT INT,
    MaDonDatPhong CHAR(10) FOREIGN KEY REFERENCES DonDatPhong(MaDonDatPhong),
    MaDonDichVu CHAR(10) FOREIGN KEY REFERENCES DonDatDichVu(MaDonDichVu),
    MaNhanVien CHAR(10) FOREIGN KEY REFERENCES NhanVien(MaNhanVien)
)
GO 

-- 19. Tạo bảng "Đổi ưu đãi"
CREATE TABLE DoiUuDai 
(
    NgayDoi DATETIME DEFAULT GETDATE(),
    MaThe CHAR(10),
    MaUuDai CHAR(10),
    PRIMARY KEY (MaThe, MaUuDai),
    FOREIGN KEY (MaThe) REFERENCES TheDiem(MaThe),
    FOREIGN KEY (MaUuDai) REFERENCES UuDai(MaUuDai)
)
GO 

-- 20. Tạo bảng "Áp dụng ưu đãi đặt phòng"
CREATE TABLE ApDungUuDaiDatPhong (
    NgayApDung DATETIME DEFAULT GETDATE(),
    MaUuDai CHAR(10),
    MaDonDatPhong CHAR(10),
    PRIMARY KEY (MaUuDai, MaDonDatPhong),
    FOREIGN KEY (MaUuDai) REFERENCES UuDai(MaUuDai),
    FOREIGN KEY (MaDonDatPhong) REFERENCES DonDatPhong(MaDonDatPhong)
)
GO 

-- 21. Tạo bảng "Áp dụng ưu đãi đặt dịch vụ"
CREATE TABLE ApDungUuDaiDichVu 
(
    NgayApDung DATETIME DEFAULT GETDATE(),
    MaUuDai CHAR(10),
    MaDonDatDichVu CHAR(10),
    PRIMARY KEY (MaUuDai, MaDonDatDichVu),
    FOREIGN KEY (MaUuDai) REFERENCES UuDai(MaUuDai),
    FOREIGN KEY (MaDonDatDichVu) REFERENCES DonDatDichVu(MaDonDichVu)
)
GO 

-- 22. Tạo bảng "Thông tin lưu trú"
CREATE TABLE ThongTinLuuTru 
(
    MaLuuTru CHAR(10) PRIMARY KEY,
    ThoiDiemNhanPhong DATETIME NOT NULL,
    ThoiDiemTraPhong DATETIME NOT NULL,
    MaKhachLuuTru CHAR(10) FOREIGN KEY REFERENCES KhachLuuTru(MaKhachLuuTru),
    MaNVPTRNhanPhong CHAR(10) FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    MaNVPTRTraPhong CHAR(10) FOREIGN KEY REFERENCES NhanVien(MaNhanVien)
)
GO 

-- 23. Tạo bảng "Kế hoạch bảo trì"
CREATE TABLE KeHoachBaoTri 
(
    MaKHBT CHAR(10) PRIMARY KEY, 
    TenKeHoach NVARCHAR(20) NOT NULL, 
    ChuKy NVARCHAR(20), 
    NgayBatDau DATE, 
    NgayKetThuc DATE, 
    ChiPhi MONEY CHECK (ChiPhi > 0), 
    KetQuaBaoTri NVARCHAR(50), 
    GhiChu NVARCHAR(100), 
    MaNhanVien CHAR(10) FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    MaCSVC CHAR(10) FOREIGN KEY REFERENCES CoSoVatChat(MaCSVC)
) 
GO
