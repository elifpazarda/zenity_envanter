#!/bin/bash

# Raporlama fonksiyonu
generate_report() {
    while true; do
        # Raporlama seçeneklerini göster
        secim=$(zenity --list --title="Raporlama" --text="Bir rapor seçin:" \
            --radiolist --column="Seçim" --column="Rapor Türü" \
            TRUE "Stokta Azalan Ürünler" \
            FALSE "En Yüksek Stoklu Ürünler" \
            FALSE "Geri Dön")

        # Eğer iptal edilirse ana menüye dön
        if [[ $? -ne 0 || "$secim" == "Geri Dön" ]]; then
            break
        fi

        case $secim in
            "Stokta Azalan Ürünler")
                threshold=$(zenity --entry --title="Stok Eşiği" --text="Lütfen stok eşik değerini girin:")

                if [[ -n "$threshold" ]]; then
                    zenity --list --title="Azalan Ürünler" \
                        --text="Stok eşiğinden az olan ürünler:" \
                        --column="Ürün Adı" --column="Stok" --column="Fiyat" \
                        $(awk -F ',' -v thresh="$threshold" 'NR>1 && $3 < thresh {print $2, $3, $4}' depo.csv)
                else
                    zenity --error --title="Hata" --text="Eşik değeri belirtilmedi!"
                fi
                ;;
            "En Yüksek Stoklu Ürünler")
                zenity --list --title="En Yüksek Stoklu Ürünler" \
                    --text="En yüksek stoğa sahip ürünler:" \
                    --column="Ürün Adı" --column="Stok" --column="Fiyat" \
                    $(sort -t ',' -k3 -nr depo.csv | awk -F ',' 'NR>1 {print $2, $3, $4}')
                ;;
            *)
                zenity --error --title="Hata" --text="Geçersiz seçim yaptınız!"
                ;;
        esac
    done
}

