#!/bin/bash

# Ürün güncelleme fonksiyonu
update_product() {
    product_id=$(awk -F ',' 'NR>1 {print $1}' depo.csv | zenity --list --title="Ürün Güncelle" --column="Ürün ID")

    if [[ -n "$product_id" ]]; then
        current_data=$(grep "^$product_id," depo.csv)
        product_name=$(echo "$current_data" | cut -d',' -f2)
        stock=$(echo "$current_data" | cut -d',' -f3)
        price=$(echo "$current_data" | cut -d',' -f4)
        category=$(echo "$current_data" | cut -d',' -f5)

        updated_product=$(zenity --forms --title="Ürün Güncelle" --text="Ürün bilgilerini düzenleyin:" \
            --add-entry="Ürün Adı (Mevcut: $product_name)" \
            --add-entry="Stok Miktarı (Mevcut: $stock)" \
            --add-entry="Birim Fiyat (Mevcut: $price)" \
            --add-entry="Kategori (Mevcut: $category)")

        updated_name=$(echo "$updated_product" | cut -d'|' -f1 | xargs)
        updated_stock=$(echo "$updated_product" | cut -d'|' -f2)
        updated_price=$(echo "$updated_product" | cut -d'|' -f3)
        updated_category=$(echo "$updated_product" | cut -d'|' -f4 | xargs)

        if [[ -z "$updated_name" || -z "$updated_category" ]]; then
            zenity --error --title="Hata" --text="Ürün adı veya kategori boş bırakılamaz!"
            echo "$(date),HATA: Güncelleme sırasında boş ürün adı veya kategori" >> log.csv
            return
        fi

        if [[ $updated_stock =~ ^[0-9]+$ ]] && [[ $updated_price =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            # İlerleme çubuğu
            (
            for i in $(seq 1 10); do
                echo $((i * 10))
                sleep 0.2
            done
            ) | zenity --progress --title="Ürün Güncelleniyor" --text="Ürün güncelleniyor, lütfen bekleyin..." --percentage=0 --auto-close

            # Güncelle
            sed -i "s/^$product_id,.*/$product_id,$updated_name,$updated_stock,$updated_price,$updated_category/" depo.csv
            zenity --info --title="Başarılı" --text="Ürün başarıyla güncellendi!"
            echo "$(date),BAŞARILI: Ürün Güncellendi, ID: $product_id, Adı: $updated_name" >> log.csv
        else
            zenity --error --title="Hata" --text="Stok miktarı ve fiyat yalnızca pozitif sayı olabilir!"
            echo "$(date),HATA: Güncelleme sırasında geçersiz stok veya fiyat" >> log.csv
        fi
    else
        zenity --error --title="Hata" --text="Geçerli bir ürün seçmediniz!"
        echo "$(date),HATA: Güncelleme için ürün seçilmedi" >> log.csv
    fi
}
