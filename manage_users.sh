#!/bin/bash

# Kullanıcı yönetimi fonksiyonu
manage_users() {
    # CSV dosyasını kontrol et ve oluştur
    if [[ ! -f "kullanici.csv" ]]; then
        echo "KullaniciAdi,Parola,Role" > kullanici.csv
    fi

    # Kullanıcı yönetim menüsü
    choice=$(zenity --list --title="Kullanıcı Yönetimi" --column="İşlem" "Yeni Kullanıcı Ekle" "Kullanıcı Sil" "Kullanıcıları Listele" "Kullanıcıları Güncelle")

    if [[ "$choice" == "Yeni Kullanıcı Ekle" ]]; then
	 new_user=$(zenity --forms --title="Yeni Kullanıcı Ekle" --text="Yeni kullanıcı bilgilerini girin:" \
	    --add-entry="Kullanıcı Adı" \
            --add-password="Parola" \
	    --add-combo="Rol" --combo-values="Yönetici|Kullanıcı")

	if [[ -n "$new_user" ]]; then
	    username=$(echo "$new_user" | cut -d'|' -f1 | xargs)
	    password=$(echo "$new_user" | cut -d'|' -f2)
	    role=$(echo "$new_user" | cut -d'|' -f3 | xargs)

	    # Eksik alan kontrolü
            if [[ -z "$username" || -z "$password" || -z "$role" ]]; then
		 zenity --error --title="Hata" --text="Tüm bilgileri doldurmanız gerekiyor!"
		 return
	    fi

	    # Kullanıcı bilgilerini CSV dosyasına ekler
	    echo "$username,$password,$role" >> kullanici.csv
	    zenity --info --title="Başarılı" --text="Kullanıcı başarıyla eklendi!\nNo: $user_no\nAdı: $username"
	else
	    zenity --error --title="Hata" --text="Kullanıcı bilgileri eksik veya işlem iptal edildi!"
	fi
    elif [[ "$choice" == "Kullanıcı Sil" ]]; then
        selected_user=$(awk -F ',' 'NR>1 {print $1}' kullanici.csv | zenity --list --title="Kullanıcı Sil" --column="Kullanıcı Adı")
        if [[ -n "$selected_user" ]]; then
            sed -i "/^$selected_user,/d" kullanici.csv
            zenity --info --title="Başarılı" --text="Kullanıcı başarıyla silindi!"
        else
            zenity --error --title="Hata" --text="Kullanıcı seçilmedi!"
        fi
    elif [[ "$choice" == "Kullanıcıları Listele" ]]; then
    	if [[ -s "kullanici.csv" ]]; then
        # Şifre sütunu olmadan listeler
        zenity --list --title="Kullanıcı Listesi" --text="Kayıtlı kullanıcılar:" \
            --column="Kullanıcı Adı" --column="Rol" \
            $(awk -F ',' 'NR>1 {print $1, $3}' kullanici.csv)
    	else
            zenity --error --title="Hata" --text="Kullanıcı listesi boş!"
        fi
    elif [[ "$choice" == "Kullanıcıları Güncelle" ]]; then
    	selected_user=$(awk -F ',' 'NR>1 {print $1}' kullanici.csv | zenity --list --title="Kullanıcı Güncelle" \
        --column="Kullanıcı Adı")
    
    if [[ -n "$selected_user" ]]; then
        updated_data=$(zenity --forms --title="Kullanıcı Güncelle" --text="Yeni bilgileri girin:" \
            --add-entry="Yeni Kullanıcı Adı" --add-password="Yeni Parola" --add-combo="Yeni Rol" \
            --combo-values="Yönetici|Kullanıcı")

        if [[ -n "$updated_data" ]]; then
            new_username=$(echo "$updated_data" | cut -d'|' -f1 | xargs)
            new_password=$(echo "$updated_data" | cut -d'|' -f2 | xargs)
            new_role=$(echo "$updated_data" | cut -d'|' -f3 | xargs)

            # Kullanıcı bilgilerini güncelle
            awk -F ',' -v user="$selected_user" -v name="$new_username" -v pass="$new_password" -v role="$new_role" \
                'BEGIN {OFS=","} {if ($1 == user) print name, pass, role; else print $0}' kullanici.csv > temp.csv && mv temp.csv kullanici.csv

            zenity --info --title="Başarılı" --text="Kullanıcı başarıyla güncellendi!"
        else
            zenity --error --title="Hata" --text="Güncelleme bilgileri eksik!"
        fi
    else
        zenity --error --title="Hata" --text="Güncellenecek kullanıcı seçilmedi!"
	fi    
    fi
}
