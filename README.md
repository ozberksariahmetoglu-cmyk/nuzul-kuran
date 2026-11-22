# Nüzul – Yaşayan Kur'an (Android)

Türkçe meal/tefsir kaynağını çevrimdışı okumak için Flutter uygulama başlangıç projesi.

## İçerik
- Kaynak PDF uygulama içine gömülüdür; PDF okuyucu internet gerektirmez.
- PDF metin dökümü üzerinden çevrimdışı kelime araması.
- Nüzul başlıklarından otomatik çıkarılmış sure başlangıç listesi (doğrulama gerektirir).
- Yerel not kaydı.
- Açık/koyu tema.
- GitHub Actions ile Android release APK derleme.

## APK üretimi
GitHub deposuna dosyaları yükleyip `Actions` sekmesinden **Android APK** iş akışını çalıştırın. Tamamlandığında `nuzul-kuran-apk` artifact'ini indirin.

## Önemli veri notu
PDF'den çıkarılan başlık listesi otomatik ön listedir; kitapta yer alan bütün sureleri ve sayfa başlangıçlarını kapsadığı henüz doğrulanmamıştır. Ayet bazlı meal/tefsir eşleştirmesi, cüzler, konu fihristi ve ayet bazlı yer imleri henüz tamamlanmış değildir. Uygulama bunları tamamlanmış gibi sunmaz.

## Kaynak
R. İhsan Eliaçık, *Nüzul Sırasına Göre Yaşayan Kur'an – Türkçe Meal/Tefsir*. Bu dosyayı yalnızca gerekli kullanım/dağıtım izinleri mevcutsa depoda ve uygulama paketinde tutun.
