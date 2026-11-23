# C-Organizer

C-Organizer adalah aplikasi utilitas baris perintah (CLI) yang dibuat dengan bahasa C untuk merapikan dan mengelompokkan file di dalam suatu folder secara otomatis berdasarkan ekstensi file tersebut.

## Fitur Utama

- **Pengelompokan Otomatis**: Memindahkan file ke folder kategori masing-masing (seperti Gambar, Dokumen, Video, Audio, Arsip, Kode, dan Lainnya).
- **Mode Dry-Run (`--dry-run`)**: Melihat pratinjau file yang akan dipindahkan tanpa benar-benar memindahkan atau mengubah file asli.
- **Mode Verbose (`--verbose`)**: Menampilkan informasi detail setiap proses pemindahan file di terminal.
- **Penanganan File Aman**: Mengabaikan file tersembunyi (hidden files) dan direktori yang sudah ada, serta mencegah penimpaan file jika nama file tujuan sudah ada.
- **Pengujian Otomatis**: Menyediakan skrip pengujian lengkap untuk memastikan semua fungsi berjalan dengan baik.

## Kategori File

- **Images**: `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.webp`, `.svg`
- **Documents**: `.pdf`, `.doc`, `.docx`, `.txt`, `.xls`, `.xlsx`, `.ppt`, `.pptx`, `.odt`
- **Videos**: `.mp4`, `.mkv`, `.avi`, `.mov`, `.wmv`, `.flv`
- **Audio**: `.mp3`, `.wav`, `.flac`, `.aac`, `.ogg`, `.m4a`
- **Archives**: `.zip`, `.rar`, `.tar`, `.gz`, `.7z`, `.tar.gz`
- **Code**: `.c`, `.h`, `.cpp`, `.hpp`, `.py`, `.js`, `.java`, `.html`, `.css`, `.sh`
- **Others**: File dengan ekstensi lain atau tanpa ekstensi.

## Cara Instalasi dan Kompilasi

Pastikan komputer Anda memiliki compiler C (seperti GCC) dan `make`.

1. **Clone repositori ini**:
   ```bash
   git clone https://github.com/username/C-Organizer.git
   cd C-Organizer
   ```

2. **Kompilasi program**:
   ```bash
   make
   ```

3. **Install program (opsional)**:
   ```bash
   make install
   ```

## Cara Penggunaan

Jalankan program dengan menentukan folder target yang ingin dirapikan:

```bash
./co /path/ke/folder/target
```

### Opsi Tambahan:
- **Melihat pratinjau saja (Dry-Run)**:
  ```bash
  ./co --dry-run /path/ke/folder/target
  ```
- **Menampilkan detail proses (Verbose)**:
  ```bash
  ./co --verbose /path/ke/folder/target
  ```
- **Kombinasi opsi**:
  ```bash
  ./co --dry-run --verbose /path/ke/folder/target
  ```

## Menjalankan Pengujian (Testing)

Untuk memastikan program berjalan dengan benar, Anda dapat menjalankan perintah pengujian otomatis:

```bash
make test
```

## Pembersihan

Untuk membersihkan file biner hasil kompilasi:

```bash
make clean
```
