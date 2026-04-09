# Kenshi Online - Quick Install Guide

## Choose Your Installer

### Windows Users

**Option 1: INSTALL.bat (Recommended)**
- English interface
- Works on all Windows versions
- Compatible with older systems

**Option 2: INSTALL_RU.bat**
- Russian interface (Русский интерфейс)
- Requires UTF-8 support
- Use if Option 1 shows encoding errors

### Linux Users

Use `install.sh` - works on all Linux distributions with Wine/Proton.

## Installation Steps

### Windows
1. Extract the archive
2. Right-click `INSTALL.bat` → Run as Administrator
3. Follow the on-screen instructions
4. Launch via desktop shortcut "Kenshi Online"

### Linux
```bash
tar -xzf kenshi-online-v*.tar.gz
cd release-package
chmod +x install.sh
./install.sh
```

## What Gets Installed

- `KenshiMP.Core.dll` - Main mod (1.3 MB)
- `KenshiMP.Injector.exe` - Game launcher
- `KenshiMP.Server.exe` - Dedicated server
- GUI layouts and configuration files
- Desktop shortcut (Windows only)

## Troubleshooting

**Installer shows weird characters?**
- Use `INSTALL.bat` instead of `INSTALL_RU.bat`

**Kenshi not found automatically?**
- Enter the full path manually when prompted
- Example: `C:\Program Files (x86)\Steam\steamapps\common\Kenshi`

**DLL copy error?**
- Close Kenshi if it's running
- Run installer as Administrator

**Game doesn't launch with mod?**
- Check that `Plugins_x64.cfg` contains `Plugin=KenshiMP.Core`
- Verify `KenshiMP.Core.dll` is in Kenshi folder

## Full Documentation

- [README.ru.md](README.ru.md) - Complete Russian documentation
- [README.md](README.md) - Original English documentation

## Support

- **Discord**: https://discord.gg/s5J5KBbsek
- **Issues**: https://github.com/im-blatnoyua/kenshi-online-simplified/issues
