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
  - Sadece ürünleri görüntüleyebilir. Yetkisi olmayan işlemlerde hata alır.
  - Rapor alabilir (stokta azalan ürünler ve en yüksek stok miktarı).
  
  <div align="left">
      <td><img width=250 src="https://github.com/user-attachments/assets/02d24035-ec89-4a05-a511-4f2bee37c8e3"
  ></td
  </div>



**Ana Menü**
- **Ürün İşlemleri**
  - **Ekleme:** Ürün bilgilerini (ad, stok, fiyat, kategori) Zenity formlarıyla ekleme.
  - **Listeleme:** Mevcut ürünleri listeleme (CSV'den okunan bilgilerle).
  - **Güncelleme:** Ürün stok veya fiyat bilgilerini değiştirme. Ürün güncelleme işlemleri ürünün ID bilgiisi kullanılarak yapılır.
  
  <div align="left">
    <td><img width=250 src="https://github.com/user-attachments/assets/b721ef80-5435-47f3-8838-12d9d2c21b9f"
  ></td
  </div> 
  
  - **Silme:** Belirli bir ürünü CSV dosyasından kaldırma.

  <div align="left">
    <td><img width=250 src="https://github.com/user-attachments/assets/35527376-054d-4d62-9ef8-d883996d473a"
  ></td
  </div> 
  
- **Raporlama**
  - Stokta azalan ürünleri eşik değeri ile listeleme.
  - En yüksek stok miktarına sahip ürünleri eşik değeri ile listeleme.
  
  <div align="left">
    <table>
        <td><img width=250 src="https://github.com/user-attachments/assets/4fdff4dd-4298-454c-b3a3-339f399175a3"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/1ffded44-d3bd-4ba6-bcf5-61ec410295c3"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/bf865f8a-66a7-4bd6-b700-5068dd0fb596"
  ></td>
    </table>
  </div>
  
- **Kullanıcı Yönetimi** (Sadece Yönetici)
  - Yeni kullanıcı ekleme
  - Kullanıcıları listeleme (şifreler gösterilmez).
  - Kullanıcı bilgilerini güncelleme 
  - Kullanıcı silme.

  <div align="left">
    <table>
        <td><img width=250 src="https://github.com/user-attachments/assets/ee796e5d-094b-4788-b0cd-489ecdb37a9f"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/b5f131e0-f89e-4ed2-a597-3dc880bde6e6"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/e8e428a2-8479-4e56-ad8d-df597e77b07e"
  ></td>
    </table>
  </div>
  
- **Program Yönetimi**
  - Diskteki alanı görüntüleme.
  - Proje dosyalarını belirlenen dizine yedekleme.
  - Hata kayıtlarını görüntüleme.
  
  <div align="left">
    <table>
        <td><img width=250 src="https://github.com/user-attachments/assets/4138ecd5-2c21-43a9-b0a0-1af6a18a1e38"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/1b7fb52b-7ff8-49ad-b91b-a413ef022934"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/7a7fedaa-6740-4e90-9a84-71185189b816"
  ></td>
    </table>
  </div>
  
- **Şifre Yönetimi**
  - Yönetici şifre sıfırlayabilir veya kilitli hesapların kilidini kaldırabilir.
  - Hatalı giriş sonrası hesap kilitlenir.
  - Yönetici kilitli hesapları açabilir.
  - 3 kere yanlış şifre girilen hesap kitlenir ve kitlendiğine dair hata mesajı verir
  
  <div align="left">
    <table>
        <td><img width=250 src="https://github.com/user-attachments/assets/03df1d7b-4081-455d-bf7f-d5fd387550d3"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/1b7fb52b-7ff8-49ad-b91b-a413ef022934"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/7a7fedaa-6740-4e90-9a84-71185189b816"
  ></td>
        <td><img width=250 src="https://github.com/user-attachments/assets/c19b1d37-36e5-4c19-ae0c-99180253fb88"
  ></td>      
    </table>
  </div>

  
- **Çıkış**
  - Kullanıcı sistemden çıkmadan önce bir onay ekranı gösterilir.
 
  <div align="left">
    <table>
        <td><img width=250 src="https://github.com/user-attachments/assets/8d9fa61a-7922-4f43-811b-f9c964b78e29"
  ></td>
        <td><img width=250 src="!https://github.com/user-attachments/assets/500c77b5-c218-420a-b21e-b8624575d3e6"
  ></td>
    </table>
  </div>


