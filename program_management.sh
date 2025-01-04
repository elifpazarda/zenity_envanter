#!/bin/bash

# Program yönetimi işlemleri
show_disk_usage() {
    df -h > /tmp/disk_usage.txt
    zenity --text-info --title="Disk Kullanımı" --filename=/tmp/disk_usage.txt --width=600 --height=400
    rm /tmp/disk_usage.txt
}


backup_files() {
    backup_dir=$(zenity --entry --title="Yedekleme Dizini" --text="Lütfen yedekleme için bir dizin girin:")

    if [[ -n "$backup_dir" ]]; then
        mkdir -p "$backup_dir"
        cp depo.csv kullanici.csv log.csv "$backup_dir"
        zenity --info --title="Başarılı" --text="Dosyalar başarıyla '$backup_dir' dizinine yedeklendi!"
    else
        zenity --error --title="Hata" --text="Yedekleme dizini belirtilmedi!"
    fi
}

show_error_logs() {
    if [[ -f "log.csv" ]]; then
        zenity --text-info --title="Hata Kayıtları" --filename=log.csv --width=600 --height=400
    else
        zenity --error --title="Hata" --text="log.csv dosyası bulunamadı!"
    fi
}

backup_files() {
    backup_dir=$(zenity --entry --title="Yedekleme Dizini" --text="Lütfen yedekleme için bir dizin girin:")

    if [[ -n "$backup_dir" ]]; then
        mkdir -p "$backup_dir"
        cp depo.csv kullanici.csv log.csv "$backup_dir"
        zenity --info --title="Başarılı" --text="Dosyalar başarıyla '$backup_dir' dizinine yedeklendi!"
    else
        zenity --error --title="Hata" --text="Yedekleme dizini belirtilmedi!"
    fi
}

program_management() {
    secim=$(zenity --list --title="Program Yönetimi" --column="Seçenekler" \
        "Diskteki Alanı Göster" "Diske Yedekle" "Hata Kayıtlarını Göster" "Geri Dön")

    case $secim in
        "Diskteki Alanı Göster")
            show_disk_usage
            ;;
        "Diske Yedekle")
            backup_files
            ;;
        "Hata Kayıtlarını Göster")
            show_error_logs
            ;;
        "Geri Dön")
            return
            ;;
        *)
            zenity --error --title="Hata" --text="Geçersiz bir seçim yaptınız!"
            ;;
    esac
}
