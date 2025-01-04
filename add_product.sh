#!/bin/bash

add_product() {
    # Mevcut en yüksek ID'yi bul
    if [[ -s "depo.csv" ]]; then
        last_id=$(awk -F ',' 'NR>1 {print $1}' depo.csv | sort -n | tail -n 1)
        new_id=$((last_id + 1))
    else
        new_id=1
    fi

    # Zenity formuyla yeni ürün bilgilerini al
    new_product=$(zenity --forms --title="Yeni Ürün Ekle" --text="Yeni ürün bilgilerini girin:" \
        --add-entry="Ürün Adı" --add-entry="Stok Miktarı" --add-entry="Birim Fiyat" \
        --add-entry="Kategori")

    if [[ -n "$new_product" ]]; then
        product_name=$(echo "$new_product" | cut -d'|' -f1 | xargs)
        stock=$(echo "$new_product" | cut -d'|' -f2)
        price=$(echo "$new_product" | cut -d'|' -f3)
        category=$(echo "$new_product" | cut -d'|' -f4 | xargs)

        # Boşluk ve negatif sayı kontrolü
        if [[ "$product_name" =~ [[:space:]] || "$category" =~ [[:space:]] ]]; then
            zenity --error --title="Hata" --text="Ürün adı veya kategori boşluk içeremez!"
            echo "$(date),HATA: Boşluk içeren ürün adı veya kategori girildi" >> log.csv
            return
        fi

        if [[ $stock =~ ^[0-9]+$ && $price =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            if [[ $stock -lt 0 || $price =~ ^- ]]; then
                zenity --error --title="Hata" --text="Stok miktarı ve fiyat pozitif olmalıdır!"
                echo "$(date),HATA: Negatif stok veya fiyat girildi" >> log.csv
                return
            fi

            # Aynı isimde ürün kontrolü
            if awk -F ',' -v name="$product_name" 'NR>1 && $2 == name {found=1} END {exit !found}' depo.csv; then
                zenity --error --title="Hata" --text="Bu ürün adıyla başka bir kayıt bulunmaktadır. Lütfen farklı bir ad giriniz."
                echo "$(date),HATA: Aynı ürün adı tekrar girilmeye çalışıldı: $product_name" >> log.csv
                return
            fi

            # İlerleme çubuğu
            (
            for i in $(seq 1 10); do
                echo $((i * 10))
                sleep 0.2
            done
            ) | zenity --progress --title="Ürün Ekleniyor" --text="Ürün ekleniyor, lütfen bekleyin..." --percentage=0 --auto-close

            # Ürün ekle
            echo "$new_id,$product_name,$stock,$price,$category" >> depo.csv
            zenity --info --title="Başarılı" --text="Ürün başarıyla eklendi!"
            echo "$(date),BAŞARILI: Ürün Eklendi, ID: $new_id, Adı: $product_name" >> log.csv
        else
            zenity --error --title="Hata" --text="Stok miktarı ve fiyat pozitif sayı olmalıdır!"
            echo "$(date),HATA: Geçersiz stok veya fiyat formatı" >> log.csv
        fi
    else
        zenity --error --title="Hata" --text="Ürün bilgileri eksik!"
        echo "$(date),HATA: Ürün bilgileri eksik girildi" >> log.csv
    fi
}





