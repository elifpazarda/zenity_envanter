#!/bin/bash
locked_users="locked_users.csv"
users_file="kullanici.csv"
log_file="log.csv"


# Yönetici Kilitli Hesap Açma
unlock_user() {
    # locked_users.csv dosyasının varlığını ve içeriğini kontrol et
    if [[ ! -f "$locked_users" || ! -s "$locked_users" ]]; then
        zenity --error --title="Hata" --text="Kilitli kullanıcı bulunamadı."
        return
    fi

    # locked_users.csv'den kullanıcıları temiz bir şekilde oku ve listele
    locked_user=$(awk '!/^\s*$/' "$locked_users" | zenity --list --title="Kilitli Hesapları Aç" --column="Kilitli Kullanıcılar")

    # Eğer bir kullanıcı seçilmediyse işlemi iptal et
    if [[ -z "$locked_user" ]]; then
        zenity --error --title="Hata" --text="Kullanıcı seçilmedi!"
        return
    fi

    # Seçilen kullanıcıyı locked_users.csv dosyasından kaldır
    grep -Fxv "$locked_user" "$locked_users" > temp.csv && mv temp.csv "$locked_users"

    # Başarı mesajı göster
    zenity --info --title="Başarılı" --text="Hesap başarıyla açıldı: $locked_user"
    echo "$(date), Yönetici, Hesap açıldı: $locked_user" >> "$log_file"
}

# Yönetici Şifre Sıfırlama
reset_password() {
    # kullanici.csv dosyasından kullanıcıları listele
    selected_user=$(awk -F ',' 'NR>1 && $1!="" {print $1}' "$users_file" | zenity --list --title="Şifre Sıfırla" --column="Kullanıcı Adı")

    # Eğer bir kullanıcı seçilmediyse işlemi iptal et
    if [[ -z "$selected_user" ]]; then
        zenity --error --title="Hata" --text="Kullanıcı seçilmedi!"
        return
    fi

    # Yeni şifre al
    new_password=$(zenity --password --title="Yeni Şifre" --text="Yeni şifreyi girin:")
    if [[ -z "$new_password" ]]; then
        zenity --error --title="Hata" --text="Şifre boş bırakılamaz!"
        return
    fi

    # Şifreyi güncelle
    awk -F ',' -v user="$selected_user" -v pass="$new_password" \
        'BEGIN {OFS=","} {if ($1 == user) $2 = pass; print $0}' "$users_file" > temp.csv && mv temp.csv "$users_file"
    zenity --info --title="Başarılı" --text="Şifre başarıyla sıfırlandı: $selected_user"
    echo "$(date), Yönetici, Şifre sıfırladı: $selected_user" >> "$log_file"
}

#Yönetici şifre sıfırlama ekranı
admin_menu() {
    while true; do
        choice=$(zenity --forms --title="Yönetici Menüsü" --text="Bir işlem seçin:" \
            --add-combo="İşlem" --combo-values="Kilitli Hesapları Aç|Şifre Sıfırla|Çıkış")

        # Kullanıcı "Cancel" düğmesine basarsa ana menüye dön
        if [[ $? -ne 0 ]]; then
            zenity --info --title="Ana Menü" --text="Bir önceki menüye dönülüyor."
            break
        fi

        # Eğer hiçbir seçim yapılmazsa (Cancel durumu), işlemi durdur
        if [[ -z "$choice" ]]; then
            zenity --info --title="Ana Menü" --text="Bir önceki menüye dönülüyor."
            break
        fi

        case "$choice" in
            "Kilitli Hesapları Aç")
                unlock_user
                ;;
            "Şifre Sıfırla")
                reset_password
                ;;
            "Çıkış")
                zenity --info --title="Çıkış" --text="Programdan çıkılıyor."
                exit 0
                ;;
            *)
                zenity --error --title="Hata" --text="Geçersiz seçim yaptınız!"
                ;;
        esac
    done
}


# Ana Başlatıcı
main() {
    admin_menu
}

main

