#!/bin/bash

#Ürün silme fonksiyonu
delete_product() {
    while true; do
        # Silme yöntemi seçimi
        method=$(zenity --list --title="Ürün Silme" --text="Ürün silme yöntemi seçin:" \
            --radiolist --column="Seçim" --column="Silme Yöntemi" \
            TRUE "Ürün ID ile Sil" FALSE "Ürün Adı ile Sil" FALSE "Geri Dön")

        # Kullanıcı "Geri Dön" seçerse veya iptal ederse işlemi sonlandır
        if [[ $? -ne 0 || "$method" == "Geri Dön" ]]; then
            break
        fi

        case "$method" in
            "Ürün ID ile Sil")
                product_id=$(awk -F ',' 'NR>1 {print $1}' depo.csv | zenity --list --title="Ürün ID ile Sil" --text="Silmek istediğiniz ürünün ID'sini seçin:" --column="Ürün ID")
                if [[ -n "$product_id" ]]; then
                    grep -v "^$product_id," depo.csv > temp.csv && mv temp.csv depo.csv
                    zenity --info --title="Başarılı" --text="Ürün başarıyla silindi: ID $product_id"
                    echo "$(date), BAŞARILI: Ürün Silindi, ID: $product_id" >> log.csv
                else
                    zenity --error --title="Hata" --text="Geçerli bir ürün ID seçilmedi!"
                fi
                ;;
            "Ürün Adı ile Sil")
                product_name=$(awk -F ',' 'NR>1 {print $2}' depo.csv | zenity --list --title="Ürün Adı ile Sil" --text="Silmek istediğiniz ürünün adını seçin:" --column="Ürün Adı")
                if [[ -n "$product_name" ]]; then
                    grep -v ",$product_name," depo.csv > temp.csv && mv temp.csv depo.csv
                    zenity --info --title="Başarılı" --text="Ürün başarıyla silindi: Adı $product_name"
                    echo "$(date), BAŞARILI: Ürün Silindi, Adı: $product_name" >> log.csv
                else
                    zenity --error --title="Hata" --text="Geçerli bir ürün adı seçilmedi!"
                fi
                ;;
            *)
                zenity --error --title="Hata" --text="Geçersiz seçim yaptınız!"
                ;;
        esac
    done
}


