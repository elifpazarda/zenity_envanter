#!/bin/bash

#Ürün listeleme fonksiyonu
list_products() {
    total_lines=$(wc -l < depo.csv)

    # Eğer sadece başlık satırı varsa hata ver
    if [[ $total_lines -le 1 ]]; then
        zenity --error --title="Hata" --text="Gösterilecek ürün bulunamadı!"
        return
    fi

    # İlerleme çubuğu için döngü
    (
    for i in $(seq 1 $total_lines); do
        echo $((i * 100 / total_lines)) # Yüzde hesaplama
        sleep 0.1
    done
    ) | zenity --progress --title="Ürün Listeleme" --text="Ürünler listeleniyor..." --percentage=0 --auto-close

    # Tablo formatında ürünleri listele
    zenity --list --title="Ürün Listesi" \
        --column="ID" --column="Ürün Adı" --column="Stok" --column="Fiyat" --column="Kategori" \
        $(awk -F ',' 'NR>1 {printf "%s %s %s %s %s\n", $1, $2, $3, $4, $5}' depo.csv) \
        --width=800 --height=400
}

