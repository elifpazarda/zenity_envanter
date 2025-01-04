# Zenity_Envanter


- Bu envanter sistemi Zenity araçları kullanılarak, ürün ekleme, listeleme, güncelleme ve silme vb. işlemlerini destekleyen, kullanıcı dostu bir grafik arayüz sağlamak amacıyla tasarlanmıştır. 

## Youtube Video Linki 
- [Envanter Sistemi Tanıtım Videosu](https://www.youtube.com/watch?v=KHBIlWConyc)

## Envanter Sistemi Hakkında
**Kullanıcı Rolleri**
- **Yönetici**
  - Ürün ve kullanıcı yönetimi dahil tüm işlemleri yapabilir.
  - Hatalı giriş sonrası kilitlenen hesapları açabilir.
  - Program yönetimi (disk alanını kontrol etme, yedek alma, hata kayıtlarını gösterme) işlemlerini yapabilir.
- **Kullanıcı**
  - Sadece ürünleri görüntüleyebilir.
  - Rapor alabilir (stokta azalan ürünler ve en yüksek stok miktarı).

---

**Ana Menü**
- **Ürün İşlemleri**
  - **Ekleme:** Ürün bilgilerini (ad, stok, fiyat, kategori) Zenity formlarıyla ekleme.
  - **Listeleme:** Mevcut ürünleri listeleme (CSV'den okunan bilgilerle).
  - **Güncelleme:** Ürün stok veya fiyat bilgilerini değiştirme.
  - **Silme:** Belirli bir ürünü CSV dosyasından kaldırma.

- **Raporlama**
  - Stokta azalan ürünleri eşik değeri ile listeleme.
  - En yüksek stok miktarına sahip ürünleri eşik değeri ile listeleme.

- **Kullanıcı Yönetimi** (Sadece Yönetici)
  - Yeni kullanıcı ekleme
  - Kullanıcıları listeleme (şifreler gösterilmez).
  - Kullanıcı bilgilerini güncelleme 
  - Kullanıcı silme.

- **Program Yönetimi**
  - Diskteki alanı görüntüleme.
  - CSV dosyalarını yedekleme.
  - Hata kayıtlarını görüntüleme.

- **Şifre Yönetimi**
  - Yönetici şifre sıfırlayabilir.
  - Hatalı giriş sonrası hesap kilitleme.
  - Yönetici kilitli hesapları açabilir.

- **Çıkış**
  - Kullanıcı sistemden çıkmadan önce bir onay ekranı gösterilir.


<div>
    <h2 align=center> Ekran Görüntüleri </h2>
</div>

<div align="center">
  <table>
    <tr>
      <th>Giriş Ekranı</th>
      <th>Ürün Silme</th>
      <th>Ana Menü</th>
      <th>Şifre Sıfırlama</th>
    </tr>
    <tr>
      <td><img width=150 src="![image](https://github.com/user-attachments/assets/3d6e6a3d-a509-4f12-a6dd-45a90192953a)
"></td>
      <td><img width=150 src="![image](https://github.com/user-attachments/assets/35527376-054d-4d62-9ef8-d883996d473a)
"></td>
      <td><img width=150 src="![image](https://github.com/user-attachments/assets/7c44d748-003b-43f2-9e65-072ed51f9275)
"></td>
      <td><img width=150 src="![image](https://github.com/user-attachments/assets/b3b4da3e-e25e-44bf-a0cb-2f0adb7cbb0f)
></td>
    </tr>
  </table>
</div>


