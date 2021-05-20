create database Managersupplies;
use Managersupplies;
# tạo bảng vật tư
create table supplies
(
    id             int auto_increment primary key,
    code_supplies  varchar(100) unique not null,
    name_supplies  varchar(100) unique not null,
    chargingunit   varchar(10)         not null,
    price_supplies double              not null
);
insert into supplies(code_supplies, name_supplies, chargingunit, price_supplies) value
    ('DL1', 'DenLed', 'sanpham', 600),
    ('Bx1', 'nước rửa kính ô tô', 'sanpham', 200),
    ('MLe1', 'ManHinh', 'sanpham', 2000),
    ('Mo01', 'Guong', 'sanpham', 3000),
    ('D005', 'Tay Lắm cửa', 'sanpham', 800);
select *
from supplies;


# Tạo bảng tồn kho
create table store
(
    id             int auto_increment primary key,
    id_supplies    int,
    constraint fk_ss foreign key (id_supplies) references supplies (id),
    first_quantity int,
    add_quantity   int,
    expot_quantity int
);
insert into store(id_supplies, first_quantity, add_quantity, expot_quantity) value
    (1, 200, 200, 150),
    (1, 150, 200, 190),
    (2, 210, 400, 170),
    (3, 20, 300, 160),
    (4, 25, 230, 10),
    (3, 52, 220, 15),
    (2, 203, 120, 50),
    (4, 20, 100, 110),
    (5, 206, 50, 10),
    (5, 29, 100, 120),
    (3, 92, 210, 100);


# Nhà cung cấp
create table supplier
(
    id               int auto_increment primary key,
    code_supplier    varchar(100) not null unique,
    name_supplier    varchar(200) not null unique,
    address_supplier varchar(200),
    phone_supplier   varchar(20)
);
insert into supplier(code_supplier, name_supplier, address_supplier, phone_supplier) value
    ('HH001', 'Hoàng Hải', 'Hải phòng', '09923333412'),
    ('AHD001', 'Auto Hà Đông', 'Hà Nội', '0923333412'),
    ('VT001', 'Vĩnh thịnh', 'Vĩnh Phúc', '092873333412'),
    ('XT001', 'Xuân Trường auto', 'Hà Nội', '09823333412'),
    ('OT001', 'CTy CNHH ototech', 'Sóc Sơn-Hà Nội', '09523333412');

select *
from supplier;

# đơn đặt hàng
create table oder
(
    id          int auto_increment primary key,
    code_oder   varchar(100) not null unique,
    date        date,
    id_supplier int,
    constraint fk_os foreign key (id_supplier) references supplier (id)
);
insert into oder(code_oder, date, id_supplier) value
    ('cd02', '2021-05-15', '5'),
    ('cd04', '2021-05-25', '4'),
    ('cd07', '2021-04-09', '2');
select *
from oder;


#phiếu nhập
create table receipt
(
    id           int auto_increment primary key,
    code_receipt varchar(100) unique not null,
    date_receipt date,
    id_oder      int,
    constraint fk_ro foreign key (id_oder) references oder (id)
);
insert into receipt(code_receipt, date_receipt, id_oder) value
    ('pn01', '2021-04-02', '1'),
    ('pn03', '2021-04-02', '4'),
    ('pn05', '2021-04-02', '3');
select *
from receipt;

#phiếu xuất
create table deliverybill
(
    id                int auto_increment primary key,
    code_deliverybill varchar(100) unique not null,
    date_delivery     date,
    customer_name     varchar(100)
);
insert into deliverybill(code_deliverybill, date_delivery, customer_name) value
    ('bill001', '2021-05-14', 'Híu'),
    ('bill1', '2021-04-02', 'Hoàng'),
    ('bill002', '2021-05-10', 'Hà');
select *
from deliverybill;


# Chi tiết đơn hàng
create table detailoder
(
    id          int auto_increment primary key,
    id_oder     int,
    id_supplies int,
    constraint fk_ds foreign key (id_supplies) references supplies (id),
    constraint fk_do foreign key (id_oder) references oder (id),
    amount      int
);
insert into detailoder(id_oder, id_supplies, amount) value
    (1, 1, 100),
    (2, 2, 122),
    (4, 4, 50),
    (6, 5, 150);
select *
from detailoder;


# chi tiết phiếu nhập
create table detailreceipt
(
    id           int auto_increment primary key,
    idd_receipt  int,
    idd_supplies int,
    constraint fk_dr foreign key (idd_receipt) references receipt (id),
    constraint fk_ds1 foreign key (idd_supplies) references supplies (id),
    amount       int,
    price        double not null,
    note         varchar(200)
);
insert into detailreceipt(idd_receipt, idd_supplies, amount, price, note) value
    (4, 2, 100, 200, ''),
    (5, 2, 120, 200, ''),
    (6, 1, 100, 200, ''),
    (4, 3, 10, 200, ''),
    (5, 4, 150, 200, ''),
    (6, 5, 100, 200, '');
select *
from detailreceipt;


# chi tiết phiếu xuất
create table detaildeliverybill
(
    id              int auto_increment primary key,
    id_deliverybill int,
    id_supplies     int,
    constraint fk_d foreign key (id_deliverybill) references deliverybill (id),
    constraint fk_d1 foreign key (id_supplies) references supplies (id),
    amount          int,
    price           double not null,
    note            varchar(200)
);
insert into detaildeliverybill(id_deliverybill, id_supplies, amount, price, note) value
    (1, 2, 100, 150, ''),
    (2, 5, 10, 300, ''),
    (3, 1, 200, 150, ''),
    (1, 4, 50, 1500, ''),
    (1, 3, 40, 1500, ''),
    (2, 2, 90, 1000, '');
select *
from detaildeliverybill;

# thưcj hành các câu lệnh
# hiển thị số phiếu nhập hàng, mã vật tư, số lượng nnhaapj , đơn giá nhập,thành tiền
use Managersupplies;
select code_receipt, idd_supplies, amount, price, price * amount
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt;

# Hiển thị bảng số phiếu nhập hàng, mã vật tư, tên vật tư,số lượng nhập, đơn giá nhập, thành tiền
use Managersupplies;
select code_receipt, idd_supplies, name_supplies, amount, price, (amount * price) as Amountmoney
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies;

# số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
select code_receipt,
       date_receipt,
       id_oder,
       idd_supplies,
       name_supplies,
       amount,
       price,
       (amount * price) as Thanhtien
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies;

# số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã nhà cung cấp, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
select code_receipt,
       date_receipt,
       id_oder,
       code_supplier,
       code_supplies,
       name_supplies,
       amount,
       price,
       (price * amount)
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies
         join oder o on o.id = receipt.id_oder
         join supplier s2 on s2.id = o.id_supplier;

# số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập có số lượng nhập > 5.
select code_receipt, code_supplies, amount, price, (price * amount)
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies
where amount > 100;

# số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là Bộ.
select code_receipt, code_supplies, name_supplies, amount, price, (price * amount)
from detailreceipt
         join receipt r on r.id = detailreceipt.idd_receipt
         join supplies s on s.id = detailreceipt.idd_supplies
where chargingunit = 'sanpham';

#số phiếu xuất hàng, mã vật tư, số lượng xuất, đơn giá xuất, thành tiền xuất.
select code_deliverybill, code_supplies, amount, price, (price * amount)
from deliverybill
         join detaildeliverybill d on deliverybill.id = d.id_deliverybill
         join supplies s on s.id = d.id_supplies;

# số phiếu xuất hàng, tên khách hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.
select code_deliverybill, customer_name, code_supplies, name_supplies, amount, price
from deliverybill
         join detaildeliverybill d on deliverybill.id = d.id_deliverybill
         join supplies s on s.id = d.id_supplies;



# baiTap view
# 1 Tạo view có tên vw_CTPNHAP bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP as
(
select code_receipt, code_supplies, amount, price, (amount * price)
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies);
select *
from vw_CTPNHAP;

# Câu 2. Tạo view có tên vw_CTPNHAP_VT bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT as
(
select code_receipt, code_supplies, name_supplies, amount, price, (price * amount)
from detailreceipt
         join receipt r on r.id = detailreceipt.idd_receipt
         join supplies s on s.id = detailreceipt.idd_supplies);
select *
from vw_CTPNHAP_VT;

# Câu 3. Tạo view có tên vw_CTPNHAP_VT_PN bao gồm các thông tin sau:
# số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng,
# mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT_PN as
(
select code_receipt,
       date_receipt,
       code_oder,
       code_supplies,
       name_supplies,
       amount,
       price,
       (price * amount)
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies
         join oder o on o.id = receipt.id_oder);
select *
from vw_CTPNHAP_VT_PN;


# Câu 4. Tạo view có tên vw_CTPNHAP_VT_PN_DH bao gồm các thông tin sau:
# số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng,
# mã nhà cung cấp, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT_PN_DH as
(
select code_receipt,
       date_receipt,
       code_oder,
       code_supplier,
       code_supplies,
       amount,
       price,
       (price * amount)
from receipt
         join oder o on o.id = receipt.id_oder
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies
         join supplier s2 on s2.id = o.id_supplier);
select *
from vw_CTPNHAP_VT_PN_DH;


#Câu 5. Tạo view có tên vw_CTPNHAP_loc  bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
# Và chỉ liệt kê các chi tiết nhập có số lượng nhập > 5.
create view vw_CTPNHAP_loc as
(
select code_receipt, code_supplies, amount, price, (price * amount)
from receipt
         join detailreceipt d on receipt.id = d.idd_receipt
         join supplies s on s.id = d.idd_supplies
where amount > 100
    );
select *
from vw_CTPNHAP_loc;

# Câu 6. Tạo view có tên vw_CTPNHAP_VT_loc bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
# Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là Bộ.
create view vw_CTPNHAP_VT_loc as
(
select code_receipt, code_supplies, name_supplies, amount, price, (price * amount)
from detailreceipt
         join receipt r on r.id = detailreceipt.idd_receipt
         join supplies s on s.id = detailreceipt.idd_supplies
where chargingunit = 'sanpham');
select *
from vw_CTPNHAP_VT_loc;


# Câu 7. Tạo view có tên vw_CTPXUAT bao gồm các thông tin sau:
# số phiếu xuất hàng, mã vật tư, số lượng xuất, đơn giá xuất, thành tiền xuất.
create view vw_CTPXUAT as
(
select code_deliverybill, code_supplies, amount, price, (price * amount)
from deliverybill
         join detaildeliverybill d on deliverybill.id = d.id_deliverybill
         join supplies s on s.id = d.id_supplies
    );
select *
from vw_CTPXUAT;


# Câu 9. Tạo view có tên vw_CTPXUAT_VT_PX bao gồm các thông tin sau:
# số phiếu xuất hàng, tên khách hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.
create view vw_CTPXUAT_VT_PX as
(
select code_deliverybill, customer_name, code_supplies, name_supplies, amount, price
from deliverybill
         join detaildeliverybill d on deliverybill.id = d.id_deliverybill
         join supplies s on s.id = d.id_supplies
    );
select * from vw_CTPXUAT_VT_PX;


# bai tap procedure


