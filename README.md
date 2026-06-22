# Atras Coffee — Bar Tracker

Order & serve tracker untuk Atras Coffee. Single-page app (HTML/JS), data tersimpan di Supabase (project "Atras Coffee").

## Menjalankan

Cukup buka `index.html` lewat web server statis apapun (Vercel, Netlify, GitHub Pages, dst). Tidak perlu build step — tidak ada `package.json`, tidak ada dependency untuk di-install.

Library Supabase di-load lewat CDN (`@supabase/supabase-js`), dan URL + key project sudah ditempel langsung di dalam `index.html`.

## Deploy ke Vercel

1. Push repo ini ke GitHub (lihat langkah di bawah).
2. Buka [vercel.com](https://vercel.com) → New Project → import repo `atras-coffee-pos`.
3. Framework preset: pilih **Other** (karena ini static HTML, bukan Next.js/dst).
4. Build command: kosongkan. Output directory: kosongkan / `.` (root).
5. Deploy.
6. Buka URL yang diberikan Vercel dari tablet/HP yang dipakai di bar.

## Database

Schema & seed data ada di `atras_coffee_schema.sql` (sudah dijalankan di Supabase project "Atras Coffee"). Tabel: `pos_tables`, `pos_menu`, `pos_orders`, `pos_order_items`, `pos_sales_log`.
