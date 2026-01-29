# Niko TV - Home Page Customization Guide

## ✅ Setup Complete!

All original NodeCast-TV files have been copied to the `custom/public/` directory on the remote server and are now mounted into the Docker container. You can modify any file and changes will appear after container restart.

### Current Configuration

**Remote Server:** `/home/kyle/niko-tv/niko-tv/custom/public/`

**Docker Volume Mount:**
```yaml
volumes:
  - ./iptvplayer/data:/app/data
  - ./custom/public:/app/public
```

**What This Means:**
- Container builds from GitHub but uses YOUR custom files via volume mount
- Any changes to files in `custom/public/` override the originals
- No need to fork or rebuild for HTML/CSS/JS changes - just restart container

---

## 📁 Available Files to Customize

### On Remote Server: `/home/kyle/niko-tv/niko-tv/custom/public/`

**HTML Pages:**
- `index.html` (58KB) - Main home page / app interface
- `login.html` (12KB) - Login page

**Styles:**
- `css/main.css` (89KB) - All application styles

**Images:**
- `img/logo-banner.png` - Logo image
- `img/placeholder.png` - Placeholder image
- `img/poster-placeholder.jpg` - Poster placeholder
- `img/screenshots/` - Screenshot images
- `favicon.svg` - Favicon

**JavaScript:**
- `js/api.js` - API communication
- `js/app.js` - Main application logic
- `js/auth.js` - Authentication
- `js/login.js` - Login page logic
- `js/icons.js` - Icon definitions
- `js/components/` - UI components
- `js/pages/` - Page modules

---

## 🎨 Quick Customization Examples

### Example 1: Change Page Title

**SSH into remote server:**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv/custom/public
nano index.html
```

**Find and change:**
```html
<title>nodecast-tv | IPTV Player</title>
```

**To:**
```html
<title>Niko TV | Your Custom IPTV Experience</title>
```

**Save (Ctrl+X, Y, Enter) and restart:**
```bash
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv
```

---

### Example 2: Change Logo

**SSH and navigate:**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv/custom/public/img
```

**Backup original:**
```bash
cp logo-banner.png logo-banner.png.backup
```

**Upload your new logo** (name it `logo-banner.png`), then restart:
```bash
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv
```

---

### Example 3: Customize Colors

**Edit CSS:**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv/custom/public/css
nano main.css
```

**Find color variables (near top of file):**
```css
:root {
  --primary-color: #6366f1;  /* Change to your brand color */
  --background-color: #000;
  --text-color: #fff;
}
```

**Save and restart:**
```bash
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv
```

---

## 🚀 Workflow for Making Changes

### Method 1: Direct SSH Editing (Quick Changes)

1. **SSH into remote:**
   ```bash
   ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
   ```

2. **Edit files:**
   ```bash
   cd /home/kyle/niko-tv/niko-tv/custom/public
   nano index.html  # or login.html, css/main.css, etc.
   ```

3. **Restart container:**
   ```bash
   cd /home/kyle/niko-tv/niko-tv
   docker compose restart nodecast-tv
   ```

4. **Test:** Visit http://192.168.1.221:3000

---

### Method 2: Local Editing (Recommended for Major Changes)

1. **Copy files from remote to local:**
   ```bash
   mkdir -p /home/apps/niko-tv/custom/public
   scp -i /root/.ssh/niko_tv_deploy -r \
     kyle@192.168.1.221:/home/kyle/niko-tv/niko-tv/custom/public/* \
     /home/apps/niko-tv/custom/public/
   ```

2. **Edit files locally** with your favorite editor

3. **Upload changes back:**
   ```bash
   scp -i /root/.ssh/niko_tv_deploy -r \
     /home/apps/niko-tv/custom/public/* \
     kyle@192.168.1.221:/home/kyle/niko-tv/niko-tv/custom/public/
   ```

4. **Restart via management script:**
   ```bash
   cd /home/apps/niko-tv
   ./manage.sh restart
   ```

---

### Method 3: Version Control (Best Practice)

**Initialize git in custom directory:**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv/custom
git init
git add .
git commit -m "Initial custom files"
```

**After making changes:**
```bash
# Edit files
nano public/index.html

# Commit changes
git add .
git commit -m "Updated home page title"

# Restart container
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv
```

---

## 🎯 Common Customization Tasks

### 1. Change Brand Name Throughout Site

```bash
cd /home/kyle/niko-tv/niko-tv/custom/public
sed -i 's/nodecast-tv/Niko TV/g' index.html login.html
docker compose restart nodecast-tv
```

### 2. Replace Logo

```bash
cd /home/kyle/niko-tv/niko-tv/custom/public/img
# Upload your logo as logo-banner.png (recommended: 200x50px PNG)
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv
```

### 3. Customize Login Page

```bash
cd /home/kyle/niko-tv/niko-tv/custom/public
nano login.html
# Modify welcome text, styling, etc.
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv
```

### 4. Add Custom JavaScript

```bash
cd /home/kyle/niko-tv/niko-tv/custom/public/js
nano custom-features.js
```

**Add your code:**
```javascript
// Custom features for Niko TV
document.addEventListener('DOMContentLoaded', () => {
  console.log('Custom features loaded!');
  // Your custom code here
});
```

**Include in index.html:**
```bash
nano /home/kyle/niko-tv/niko-tv/custom/public/index.html
```

**Add before closing `</body>`:**
```html
  <script src="js/custom-features.js"></script>
</body>
```

---

## 🧪 Testing Changes

### From Remote Server
```bash
curl http://localhost:3000 | head -50
```

### From Monitoring Server
```bash
curl http://192.168.1.221:3000 | head -50
```

### Browser
- Open: http://192.168.1.221:3000
- Press F12 → Console to check for errors

---

## 🔄 Deployment Notes

### When to Restart Container

**Just restart (no rebuild needed):**
- ✅ HTML changes
- ✅ CSS changes
- ✅ JavaScript changes
- ✅ Image replacements

```bash
docker compose restart nodecast-tv
```

### When to Use Deploy Button

The monitoring dashboard deploy button is for updating the **base NodeCast-TV application** from GitHub.

**Use deploy button when:**
- NodeCast-TV releases updates
- Updating the core application

**Don't use for:**
- Custom file changes (just restart container)

---

## 🛡️ Backup Your Customizations

### Create Backup

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
tar -czf custom-backup-$(date +%Y%m%d).tar.gz custom/
```

### Download to Monitoring Server

```bash
scp -i /root/.ssh/niko_tv_deploy \
  kyle@192.168.1.221:/home/kyle/niko-tv/niko-tv/custom-backup-*.tar.gz \
  /home/apps/niko-tv/backups/
```

### Restore from Backup

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
tar -xzf custom-backup-YYYYMMDD.tar.gz
docker compose restart nodecast-tv
```

---

## 🐛 Troubleshooting

### Changes Not Appearing

1. **Hard restart:**
   ```bash
   docker compose down && docker compose up -d
   ```

2. **Clear browser cache:** Ctrl+Shift+R

3. **Check permissions:**
   ```bash
   ls -la /home/kyle/niko-tv/niko-tv/custom/public/
   ```

### Container Won't Start

```bash
# Check logs
docker compose logs nodecast-tv

# If broken, restore from backup
tar -xzf custom-backup-YYYYMMDD.tar.gz
docker compose restart nodecast-tv
```

### Styles Missing

```bash
# Verify CSS exists and has content
ls -lh /home/kyle/niko-tv/niko-tv/custom/public/css/main.css
# Should be ~89KB

# If corrupted, restore from backup
```

---

## 📚 File Reference

### Safe to Customize

- ✅ Page titles and metadata
- ✅ Color schemes in CSS
- ✅ Logo and images
- ✅ Custom JavaScript additions
- ✅ Favicon
- ✅ Text content

### Use Caution

- ⚠️ `js/app.js` - Core app logic
- ⚠️ `js/api.js` - API endpoints
- ⚠️ HTML structure in index.html

### Don't Delete

- ❌ `index.html` - Main interface
- ❌ `css/main.css` - All styles
- ❌ `js/app.js` - Core logic
- ❌ `js/api.js` - API communication
- ❌ `js/auth.js` - Authentication

---

## 📞 Quick Reference Commands

```bash
# SSH to remote
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221

# Navigate to custom files
cd /home/kyle/niko-tv/niko-tv/custom/public

# Edit home page
nano index.html

# Edit styles
nano css/main.css

# Restart container
cd /home/kyle/niko-tv/niko-tv
docker compose restart nodecast-tv

# View logs
docker compose logs nodecast-tv -f

# Test
curl http://localhost:3000
```

---

## ✨ What You Can Customize

- ✅ Page titles and meta tags
- ✅ Logo and branding
- ✅ Color schemes
- ✅ Fonts
- ✅ Welcome messages
- ✅ Login page design
- ✅ Navigation layout
- ✅ Custom JavaScript features
- ✅ Images and icons
- ✅ Footer content

---

**Current Status:** ✅ All files ready for customization

**Access:** http://192.168.1.221:3000

**Monitoring Dashboard:** http://localhost:5005 → Niko TV

**Location:** `/home/kyle/niko-tv/niko-tv/custom/public/`
