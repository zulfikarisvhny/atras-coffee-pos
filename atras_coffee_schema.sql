-- ============================================================
-- ATRAS COFFEE — BAR TRACKER SCHEMA
-- Jalankan seluruh file ini sekali di Supabase SQL Editor
-- (Project: Atras Coffee)
-- ============================================================

-- 1. Meja / kursi fisik di toko
create table if not exists pos_tables (
  id text primary key,
  name text not null,
  x numeric not null default 50,   -- posisi % horizontal di peta
  y numeric not null default 50,   -- posisi % vertikal di peta
  created_at timestamptz default now()
);

-- 2. Daftar menu
create table if not exists pos_menu (
  id text primary key,
  name text not null,
  price integer not null,
  category text not null,
  created_at timestamptz default now()
);

-- 3. Pesanan yang sedang aktif (1 baris per meja yang lagi jalan)
create table if not exists pos_orders (
  table_id text primary key references pos_tables(id) on delete cascade,
  payment_method text,             -- null = belum bayar, 'cash', atau 'qris'
  created_at timestamptz default now()
);

-- 4. Item-item di dalam pesanan aktif
create table if not exists pos_order_items (
  id text primary key,
  table_id text not null references pos_orders(table_id) on delete cascade,
  menu_id text,
  name text not null,
  price integer not null,
  qty integer not null,
  status text not null default 'pending',   -- 'pending' atau 'served'
  added_at timestamptz default now()
);

-- 5. Log histori penjualan — ditulis otomatis setiap kali meja "ditutup"
--    Berguna buat laporan penjualan nanti (item terlaris, omzet harian, dst)
create table if not exists pos_sales_log (
  id uuid primary key default gen_random_uuid(),
  table_id text not null,
  table_name text,
  items jsonb not null,
  total integer not null,
  payment_method text,
  closed_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Dibuka penuh dulu (anon key bisa baca+tulis semua) karena ini
-- alat internal 1 toko tanpa login. Bisa diperketat nanti kalau
-- mau tambah login staff.
-- ============================================================
alter table pos_tables enable row level security;
alter table pos_menu enable row level security;
alter table pos_orders enable row level security;
alter table pos_order_items enable row level security;
alter table pos_sales_log enable row level security;

drop policy if exists "anon full access" on pos_tables;
drop policy if exists "anon full access" on pos_menu;
drop policy if exists "anon full access" on pos_orders;
drop policy if exists "anon full access" on pos_order_items;
drop policy if exists "anon full access" on pos_sales_log;

create policy "anon full access" on pos_tables for all using (true) with check (true);
create policy "anon full access" on pos_menu for all using (true) with check (true);
create policy "anon full access" on pos_orders for all using (true) with check (true);
create policy "anon full access" on pos_order_items for all using (true) with check (true);
create policy "anon full access" on pos_sales_log for all using (true) with check (true);

-- ============================================================
-- SEED DATA
-- ============================================================

insert into pos_tables (id, name, x, y) values
('t1','A1',16,24),('t2','A2',38,24),('t3','A3',60,24),('t4','A4',82,24),
('t5','B1',16,62),('t6','B2',38,62),('t7','B3',60,62),('t8','B4',82,62)
on conflict (id) do nothing;

insert into pos_menu (id, name, price, category) values
('m1','Indomie Ayam Special',9000,'Noodles'),
('m2','Indomie Ayam Bawang',9000,'Noodles'),
('m3','Indomie Soto',9000,'Noodles'),
('m4','Indomie Goreng Original',9000,'Noodles'),
('m5','Indomie Goreng Aceh',9000,'Noodles'),
('m6','Indomie Goreng Rendang',9000,'Noodles'),
('m7','Mie Sedap Goreng',9000,'Noodles'),
('m8','Mie Sedap Salero Padang',9000,'Noodles'),
('m9','Mie Dok Dok',13000,'Noodles'),
('m10','Add On Telur',3000,'Add On'),
('m11','Kentang',10000,'Snack'),
('m12','Cireng (isi 7)',10000,'Snack'),
('m13','Nugget (isi 5)',10000,'Snack'),
('m14','Kopi Tubruk',9000,'Classic Coffee'),
('m15','Kopi Tubruk SKM',10000,'Classic Coffee'),
('m16','Kopi Tubruk Jahe',10000,'Classic Coffee'),
('m17','Americano',10000,'Classic Coffee'),
('m18','Kopsu Atras',13000,'Kopi Susu'),
('m19','Kopsu Atras Creamy',16000,'Kopi Susu'),
('m20','Kopsu Gula Aren',15000,'Kopi Susu'),
('m21','Kopsu Salted Caramel',15000,'Kopi Susu'),
('m22','Kopsu Hazelnut',15000,'Kopi Susu'),
('m23','Kopsu Rum',15000,'Kopi Susu'),
('m24','Kopsu Butterscotch',15000,'Kopi Susu'),
('m25','Kopsu Banana',15000,'Kopi Susu'),
('m26','Kopsu Vanilla',15000,'Kopi Susu'),
('m27','Moccacino',15000,'Kopi Susu'),
('m28','Americano SLS',15000,'Coffee Mocktails'),
('m29','Seltin Sweet',15000,'Coffee Mocktails'),
('m30','Tiffa Latina',15000,'Coffee Mocktails'),
('m31','Angela White',15000,'Coffee Mocktails'),
('m32','Susu Karamel',12000,'Milk Based'),
('m33','Susu Salted Caramel',12000,'Milk Based'),
('m34','Susu Rum',12000,'Milk Based'),
('m35','Susu Butterscotch',12000,'Milk Based'),
('m36','Susu Hazelnut',12000,'Milk Based'),
('m37','Susu Vanilla',12000,'Milk Based'),
('m38','Milkshake Strawberry',12000,'Milk Based'),
('m39','Matcha',12000,'Milk Based'),
('m40','Chocolate',12000,'Milk Based'),
('m41','Choco Cream Latte',12000,'Milk Based'),
('m42','Chocoberry',14000,'Milk Based'),
('m43','Autumn Falls',13000,'Refreshments'),
('m44','Sweetie Fox',13000,'Refreshments'),
('m45','Candy Love',13000,'Refreshments'),
('m46','Fizz Passion',13000,'Refreshments')
on conflict (id) do nothing;
