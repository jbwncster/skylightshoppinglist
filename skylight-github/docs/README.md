# Skylight Shopping List - Linux 🐧🛒

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)
![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![GTK4](https://img.shields.io/badge/GTK-4.0-green.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**Native Linux app with GTK4, camera scanning, barcode reading, and manual photo upload**

[Installation](#-installation) • [Features](#-features) • [Building](#-building) • [Contributing](#-contributing)

</div>

---

## ✨ Features

### 📸 Advanced Camera & Photo Support
- **Webcam capture** with OpenCV
- **Manual photo upload** from any folder
- **Drag & drop** image files
- **ML-powered text recognition**
- **Multiple image formats** (JPEG, PNG, WebP, GIF)

### 🏷️ Barcode Scanning
- **zbar integration** for barcode detection
- **OpenFoodFacts API** for product info
- Support for UPC, EAN, Code 128, QR codes
- **750,000+ products** in database

### 🛒 Skylight Integration
- Real-time API sync
- Shopping list management
- Check off items
- Share lists

### 📦 Pantry Management
- Store items with photos
- Nutrition tracking
- Category organization
- Search and filter
- Expiry dates

### 🎨 Native Linux Design
- **GTK4** modern toolkit
- **libadwaita** for GNOME styling
- **Responsive layouts**
- **Dark mode** support
- Follows Linux HIG

---

## 📦 Installation

### Arch Linux / Manjaro

```bash
# Install from AUR
yay -S skylight-shopping-list

# Or build from source
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-linux.git
cd skylight-shopping-list-linux/packaging/arch
makepkg -si
```

### Ubuntu / Debian (Snap)

```bash
# Install from Snap Store
sudo snap install skylight-shopping-list

# Or from file
sudo snap install skylight-shopping-list_1.0.0_amd64.snap --dangerous
```

### Fedora / Any Linux (Flatpak)

```bash
# Install from Flathub
flatpak install flathub com.skylight.shoppinglist

# Or from file
flatpak install skylight-shopping-list.flatpak

# Run
flatpak run com.skylight.shoppinglist
```

### From Source

```bash
# Install dependencies (Arch)
sudo pacman -S python gtk4 libadwaita python-gobject \
               python-requests python-pillow opencv python-opencv \
               python-pyzbar zbar meson ninja

# Install dependencies (Ubuntu/Debian)
sudo apt install python3 python3-gi python3-gi-cairo \
                 gir1.2-gtk-4.0 gir1.2-adw-1 \
                 python3-requests python3-pil \
                 python3-opencv python3-pyzbar libzbar0 \
                 meson ninja-build

# Clone and build
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-linux.git
cd skylight-shopping-list-linux
meson setup build
meson compile -C build
sudo meson install -C build
```

---

## 🚀 Usage

### Getting Started

1. **Launch Application**
   ```bash
   skylight-shopping-list
   ```

2. **Login with Skylight Credentials**
   - Enter Frame ID
   - Select auth type
   - Paste token
   - Click Connect

3. **Start Scanning!**

### Camera Scanning

#### Take Photo
1. Click **"📸 Take Photo"**
2. Allow camera permissions
3. Position items in frame
4. Click capture
5. Review detected items

#### Upload Photo (NEW)
1. Click **"📁 Upload Photo"**
2. Browse to image file
3. Select photo from:
   - Pictures folder
   - Downloads folder
   - Any location
4. Image loads in preview
5. Click **"🔍 Scan for Items"**

#### Drag & Drop (NEW)
1. Open file manager
2. Navigate to photo
3. Drag image onto app window
4. Drop to load
5. Scan automatically

### Barcode Scanning

1. Click **"🏷️ Scan Barcode"**
2. Position barcode in camera
3. Wait for automatic detection
4. View product info from OpenFoodFacts
5. Add to pantry with nutrition data

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+O` | Upload photo |
| `Ctrl+Shift+C` | Take camera photo |
| `Ctrl+B` | Scan barcode |
| `Ctrl+S` | Scan current image |
| `Ctrl+Q` | Quit application |
| `Ctrl+,` | Open settings |

---

## 🏗️ Architecture

### Tech Stack

- **Python 3.10+** - Core language
- **GTK4** - UI toolkit
- **libadwaita** - GNOME widgets
- **OpenCV** - Camera & image processing
- **zbar** - Barcode detection
- **PIL/Pillow** - Image manipulation
- **Requests** - HTTP client

### Project Structure

```
skylight-shopping-list-linux/
├── src/
│   ├── main.py                     # Application entry
│   ├── lib/
│   │   ├── skylight_api.py         # Skylight API client
│   │   ├── openfoodfacts_api.py    # OpenFoodFacts client
│   │   ├── camera_scanner.py       # Camera capture
│   │   ├── barcode_scanner.py      # Barcode detection
│   │   ├── pantry_manager.py       # Local storage
│   │   └── image_processor.py      # Image utils
│   └── ui/
│       ├── login_window.py         # Login screen
│       ├── main_window.py          # Main interface
│       ├── camera_view.py          # Camera tab
│       ├── pantry_view.py          # Pantry tab
│       └── settings_view.py        # Settings tab
├── data/
│   ├── com.skylight.shoppinglist.desktop
│   ├── com.skylight.shoppinglist.appdata.xml
│   └── icons/
├── packaging/
│   ├── arch/
│   │   └── PKGBUILD                # Arch Linux package
│   ├── flatpak/
│   │   └── com.skylight.shoppinglist.json
│   └── snap/
│       └── snapcraft.yaml          # Ubuntu Snap
├── meson.build
├── requirements.txt
├── README.md
└── LICENSE
```

---

## 🔨 Building

### Build Requirements

**All Distributions:**
- Meson >= 0.59
- Ninja >= 1.10
- Python >= 3.10
- GTK4 >= 4.10
- libadwaita >= 1.4

### Build Steps

```bash
# Configure
meson setup build \
  --prefix=/usr \
  --buildtype=release

# Compile
meson compile -C build

# Test (optional)
meson test -C build

# Install
sudo meson install -C build

# Uninstall
sudo ninja -C build uninstall
```

### Building Packages

#### Arch Linux Package

```bash
cd packaging/arch
makepkg -si
```

#### Flatpak

```bash
# Install flatpak-builder
sudo apt install flatpak-builder  # Ubuntu
sudo pacman -S flatpak-builder     # Arch

# Build
flatpak-builder --force-clean build-dir \
  packaging/flatpak/com.skylight.shoppinglist.json

# Install locally
flatpak-builder --user --install --force-clean build-dir \
  packaging/flatpak/com.skylight.shoppinglist.json

# Create bundle
flatpak build-bundle ~/.local/share/flatpak/repo \
  skylight-shopping-list.flatpak \
  com.skylight.shoppinglist
```

#### Snap

```bash
# Install snapcraft
sudo snap install snapcraft --classic

# Build
cd packaging/snap
snapcraft

# Install
sudo snap install skylight-shopping-list_1.0.0_amd64.snap --dangerous
```

---

## 📸 Manual Photo Upload Details

### Supported Formats

- **JPEG** (.jpg, .jpeg)
- **PNG** (.png)
- **WebP** (.webp)
- **GIF** (.gif)
- **BMP** (.bmp)
- **TIFF** (.tiff, .tif)

### How It Works

1. **File Dialog**
   - Native GTK4 file chooser
   - Filters to show only images
   - Preview thumbnails
   - Recent files support

2. **Drag & Drop**
   - Drag from any file manager
   - Drop onto app window
   - Automatic format detection
   - Multi-file support (processes first)

3. **Image Processing**
   - Automatic orientation correction
   - EXIF data parsing
   - Resize for optimal scanning
   - Memory-efficient loading

### Upload Sources

Photos can be uploaded from:
- **Pictures** folder (`~/Pictures`)
- **Downloads** folder (`~/Downloads`)
- **External drives** (USB, SD cards)
- **Network locations** (if mounted)
- **Any directory** with read permission

### Best Practices

- **Resolution**: 1920x1080 or higher
- **Lighting**: Well-lit, avoid shadows
- **Focus**: Clear, not blurry
- **Angle**: Straight-on shots work best
- **Format**: JPEG recommended for speed

---

## 🐛 Troubleshooting

### Camera Not Working

**Issue**: "No camera detected"

**Solutions**:
```bash
# Check camera devices
ls /dev/video*

# Test camera with v4l2
v4l2-ctl --list-devices

# Grant permissions (if using Flatpak)
flatpak override --user --device=all com.skylight.shoppinglist

# Grant permissions (if using Snap)
sudo snap connect skylight-shopping-list:camera
```

### Barcode Not Detected

**Issue**: Barcode won't scan

**Solutions**:
- Ensure good lighting
- Try different angles
- Check barcode is supported format
- Clean camera lens
- Upload high-res photo instead

### Photo Upload Fails

**Issue**: "Failed to load image"

**Solutions**:
```bash
# Check file permissions
ls -l /path/to/photo.jpg

# Check if file is readable
file /path/to/photo.jpg

# For Flatpak, grant filesystem access
flatpak override --user --filesystem=home com.skylight.shoppinglist

# For Snap, connect interfaces
sudo snap connect skylight-shopping-list:removable-media
```

### Dependencies Missing

**Issue**: Import errors

**Solutions**:
```bash
# Arch Linux
sudo pacman -S python-opencv python-pyzbar python-pillow

# Ubuntu/Debian
sudo apt install python3-opencv python3-pyzbar python3-pil

# Pip (if system packages unavailable)
pip3 install --user opencv-python pyzbar Pillow
```

---

## 🌍 Distribution-Specific Notes

### Arch Linux / Manjaro

- Available in AUR: `skylight-shopping-list`
- Use `yay` or `paru` for easy installation
- Rolling release, always latest dependencies

### Ubuntu / Pop!_OS / Linux Mint

- Snap is recommended method
- Requires `snapd` installed
- Automatic updates via Snap Store

### Fedora / RHEL / CentOS

- Flatpak is recommended method
- Enable Flathub repository first
- Compatible with Fedora 38+

### Debian

- Flatpak or build from source
- May need backports for GTK4
- Compatible with Debian 12+

### openSUSE

- Use Flatpak or build from source
- Available in `devel:languages:python` repo
- Compatible with Tumbleweed and Leap 15.5+

---

## 🚧 Roadmap

- [ ] **Wayland clipboard** - Better clipboard support
- [ ] **Portal integration** - Use XDG portals
- [ ] **Notifications** - Desktop notifications
- [ ] **System tray** - Background operation
- [ ] **Nautilus integration** - Right-click scan
- [ ] **DBus service** - System integration
- [ ] **ARM support** - Raspberry Pi compatibility
- [ ] **Translations** - Multi-language support

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

### Development Setup

```bash
# Clone repo
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-linux.git
cd skylight-shopping-list-linux

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run in development mode
python3 src/main.py
```

### Testing

```bash
# Run tests
meson test -C build

# Run with debug output
G_MESSAGES_DEBUG=all python3 src/main.py

# Check code style
flake8 src/
black src/
```

---

## 📝 License

MIT License - see [LICENSE](LICENSE)

---

## 🙏 Acknowledgments

- **Skylight API**: [github.com/mightybandito/Skylight](https://github.com/mightybandito/Skylight)
- **OpenFoodFacts**: [openfoodfacts.org](https://world.openfoodfacts.org/)
- **GTK**: [gtk.org](https://www.gtk.org/)
- **GNOME**: [gnome.org](https://www.gnome.org/)
- **OpenCV**: [opencv.org](https://opencv.org/)
- **zbar**: [github.com/mchehab/zbar](https://github.com/mchehab/zbar)

---

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/skylight-shopping-list-linux/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/skylight-shopping-list-linux/discussions)
- **Matrix**: #skylight-shopping-list:matrix.org

---

<div align="center">

**Made with ❤️ and Python for Linux**

⭐ Star this repo if you find it helpful!

</div>
