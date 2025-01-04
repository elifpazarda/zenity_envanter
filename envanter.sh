#!/bin/bash

# Gerekli dosyaları kontrol eden ve oluşturan fonksiyon
check_files() {
    if [[ ! -f "depo.csv" ]]; then
        echo "depo.csv dosyası oluşturuluyor..."
        echo "ID,Ad,Stok,Fiyat,Kategori" > depo.csv
    fi
    if [[ ! -f "kullanici.csv" ]]; then
        echo "kullanici.csv dosyası oluşturuluyor..."
        echo "KullaniciAdi,Parola,Role" > kullanici.csv
        echo "admin,admin123,Yönetici" >> kullanici.csv
    fi
    if [[ ! -f "log.csv" ]]; then
        echo "log.csv dosyası oluşturuluyor..."
        echo "Tarih,Islem,Hata" > log.csv
    fi
} 


#Kullanıcı giriş fonksiyonu
user_login() {
    local attempts=0
    local max_attempts=3
    local locked_users="locked_users.csv"
    local username=""
    local password=""

    # Kilitli kullanıcı dosyası oluşturulmamışsa oluştur
    [ ! -f "$locked_users" ] && touch "$locked_users"

    # Şifre doğrulama döngüsü
    while (( attempts < max_attempts )); do
        # Kullanıcı adı ve şifreyi aynı ekranda al
        login_data=$(zenity --forms --title="Kullanıcı Girişi" --text="Lütfen giriş bilgilerinizi girin:" \
            --add-entry="Kullanıcı Adı" --add-password="Şifre")

        if [[ -n "$login_data" ]]; then
            username=$(echo "$login_data" | cut -d'|' -f1 | xargs)
            password=$(echo "$login_data" | cut -d'|' -f2 | xargs)

            # Boş giriş kontrolü
            if [[ -z "$username" || -z "$password" ]]; then
                zenity --error --text="Kullanıcı adı ve şifre boş bırakılamaz!"
                continue
            fi

            # Kilitli kullanıcı kontrolü
            if grep -q "^$username$" "$locked_users"; then
                zenity --error --text="Bu hesap kilitli. Lütfen yönetici ile iletişime geçin."
                echo "$(date), $username, Kilitli hesap erişim denemesi" >> log.csv
                exit 1
            fi

            # Kullanıcı ve şifre doğrulama
            user_info=$(awk -F ',' -v user="$username" -v pass="$password" 'NR>1 && $1==user && $2==pass {print $0}' kullanici.csv)
            if [[ -n "$user_info" ]]; then
                user_role=$(echo "$user_info" | cut -d',' -f3)
                zenity --info --title="Başarılı Giriş" --text="Hoş geldiniz, $username! Rolünüz: $user_role"
                return 0
            else
                ((attempts++))
                zenity --error --text="Hatalı kullanıcı adı veya şifre. Kalan deneme hakkınız: $((max_attempts - attempts))"
                echo "$(date), $username, Hatalı giriş" >> log.csv
            fi
        else
            zenity --error --text="Giriş bilgileri eksik!"
            echo "$(date), HATA: Kullanıcı giriş bilgileri eksik" >> log.csv
            continue
        fi
    done

    # Hesabı kilitle
    echo "$username" >> "$locked_users"
    zenity --error --text="Hesabınız kilitlendi. Yönetici ile iletişime geçin."
    echo "$(date), $username, Hesap kilitlendi" >> log.csv
    exit 1
}




# Yetki kontrol fonksiyonu
check_permissions() {
    action=$1
    user_role=$(awk -F ',' -v user="$current_user" 'NR>1 && $1==user {print $3}' kullanici.csv)

    case $user_role in
    "Yönetici")
        return 0  # Yönetici tüm yetkilere sahiptir
        ;;
    "Kullanıcı")
        if [[ "$action" == "listele" || "$action" == "rapor" ]]; then
            return 0  # Kullanıcı yalnızca listeleme ve raporlama işlemleri yapabilir
        else
            return 1  # Yetkisiz işlem
        fi
        ;;
    *)
        return 1  # Geçersiz kullanıcı ya da rol
        ;;
    esac
}

# Yönetici Kilitli Hesap Açma
unlock_user() {
    locked_user=$(cat "$locked_users" | zenity --list --title="Hesap Açma" --column="Kilitli Kullanıcılar")
    if [[ -n "$locked_user" ]]; then
        grep -v "^$locked_user$" "$locked_users" > temp.csv && mv temp.csv "$locked_users"
        zenity --info --title="Başarılı" --text="Hesap başarıyla açıldı: $locked_user"
        echo "$(date), Yönetici, Hesap açıldı: $locked_user" >> "$log_file"
    else
        zenity --error --title="Hata" --text="Kullanıcı seçilmedi!"
    fi
}


# Ana menü fonksiyonu
# Ana menü
main_menu() {
    while true; do
        if [[ "$user_role" == "Yönetici" ]]; then
            # Yönetici Menüsü
            secim=$(zenity --list --title="Ana Menü" --column="Seçenekler" \
                "Ürün Ekle" \
                "Ürün Listele" \
                "Ürün Güncelle" \
                "Ürün Sil" \
                "Rapor Al" \
                "Kullanıcı Yönetimi" \
                "Program Yönetimi" \
                "Şifre Sıfırlama" \
                "Çıkış")
        elif [[ "$user_role" == "Kullanıcı" ]]; then
            # Kullanıcı Menüsü
            secim=$(zenity --list --title="Ana Menü" --column="Seçenekler" \
                "Ürün Ekle" \
                "Ürün Listele" \
                "Ürün Güncelle" \
                "Ürün Sil" \
                "Rapor Al" \
                "Kullanıcı Yönetimi" \
                "Program Yönetimi" \
                "Şifre Sıfırlama" \
                "Çıkış")
        else
            zenity --error --title="Hata" --text="Geçersiz kullanıcı!"
            exit 1
        fi

        case $secim in
        "Ürün Ekle")
            if [[ "$user_role" == "Yönetici" ]]; then
            	source add_product.sh
                add_product
            else
                zenity --error --title="Yetki Hatası" --text="Bu işlemi yapma yetkiniz yok!"
            fi
            ;;
        "Ürün Listele")
            source list_products.sh
            list_products
            ;;
        "Ürün Güncelle")
            if [[ "$user_role" == "Yönetici" ]]; then
            	source update_product.sh
                update_product
            else
                zenity --error --title="Yetki Hatası" --text="Bu işlemi yapma yetkiniz yok!"
            fi
            ;;
        "Ürün Sil")
            if [[ "$user_role" == "Yönetici" ]]; then
                source delete_product.sh
                delete_product
            else
                zenity --error --title="Yetki Hatası" --text="Bu işlemi yapma yetkiniz yok!"
            fi
            ;;
        "Rapor Al")
            source generate_report.sh
            generate_report
            ;;
        "Kullanıcı Yönetimi")
            if [[ "$user_role" == "Yönetici" ]]; then
                source manage_users.sh
                manage_users
            else
                zenity --error --title="Yetki Hatası" --text="Bu işlemi yapma yetkiniz yok!"
            fi
            ;;
        "Program Yönetimi")
            if [[ "$user_role" == "Yönetici" ]]; then
            	source program_management.sh
            	program_management
            else
                zenity --error --title="Yetki Hatası" --text="Bu işlemi yapma yetkiniz yok!"
            fi
            ;;
         "Şifre Sıfırlama")
            if [[ "$user_role" == "Yönetici" ]]; then
                source reset_password.sh
                reset_password
            else
                zenity --error --title="Yetki Hatası" --text="Bu işlemi yapma yetkiniz yok!"
            fi
            ;;
 	 "Çıkış")
          # Çıkış onay penceresi
          zenity --question --title="Çıkış Onayı" --text="Sistemden çıkmak istediğinizden emin misiniz?"

          # Kullanıcı evet dediyse çıkış yap
            if [[ $? -eq 0 ]]; then
            	zenity --info --title="Çıkış" --text="Sistemden çıkılıyor!"
            	exit 0
            else
            	zenity --info --title="İptal" --text="Çıkış işlemi iptal edildi."
            fi
            ;;
    	 *)
            zenity --error --title="Hata" --text="Geçersiz bir seçim yaptınız!"
            ;;
        esac
    done
}


# Script başlangıcı
check_files
user_login
main_menu

