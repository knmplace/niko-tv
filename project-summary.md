# Niko-TV Project Summary

## Project Overview
Niko-TV is a web-based streaming application featuring Live TV, VOD (movies/series), TV Guide (EPG), and a dashboard interface.

**Technology Stack:**
- Frontend: Vanilla JavaScript, HTML5, CSS3
- Video Playback: HLS.js for adaptive streaming
- Backend: Node.js/Express server
- Responsive Design: Mobile-first approach with extensive iOS optimization

---

## Recent Work: iOS Mobile Optimization (January 29, 2026)

### Initial Problem Report

**Reported Issues:**
1. **iPhone Landscape Mode**: Video picture disappears (audio continues), only returns when switching back to portrait
2. **iPhone/iPad Scrolling**: Unable to scroll vertically on home page (portrait and landscape)
3. **iPad Scrolling**: Sometimes freezes during use
4. **Working Correctly**: PC (all browsers), iPad landscape/portrait for video playback

**Testing Devices:**
- iPhone (portrait and landscape)
- iPad (portrait and landscape)
- PC/Desktop (Chrome, Firefox) ✅ Working

---

## Implementation Log

### Phase 1: Initial Diagnosis & Backup Creation

**Date:** January 29, 2026

**Backup Files Created:**
```bash
/home/apps/niko-tv/public/js/pages/WatchPage.js.backup.v1
/home/apps/niko-tv/public/js/components/VideoPlayer.js.backup.v1
/home/apps/niko-tv/public/css/main.css.backup.v1
```

**Root Cause Analysis:**

1. **Landscape Video Disappearing:**
   - `--vh` CSS variable calculated once on page load (WatchPage.js:120-127)
   - Never recalculates when device rotates from portrait to landscape
   - Stale height value pushes video container off-screen
   - Audio keeps playing because video element exists, just positioned incorrectly

2. **iPhone Cannot Scroll:**
   - Missing `{ passive: true }` flag on touch event listener (WatchPage.js:198)
   - iOS blocks scroll optimization when listener might call `preventDefault()`
   - Missing `-webkit-overflow-scrolling: touch` on `.watch-page` container
   - Touch events capture without allowing propagation to scroll container

3. **iPad Scrolling Freezes:**
   - Same root causes as iPhone
   - iPad viewport behavior differs between orientations
   - Lack of orientation-aware updates compounds the issue

---

### Phase 2: Initial Fixes Applied

#### Change 1: Dynamic Viewport Updates with Orientation Detection

**File:** `/home/apps/niko-tv/public/js/pages/WatchPage.js` (Lines 100-127)

**Changes:**
- Combined `updateIosUiBottom()` and viewport height calculation into single `updateIosViewport()` function
- Added `orientationchange` event listener with 100ms delay
- Recalculate both `--ios-ui-bottom` AND `--vh` on every update
- Kept existing `visualViewport` resize/scroll listeners
- Added fallback `resize` listener for devices without visualViewport

**Code Added:**
```javascript
const updateIosViewport = () => {
    let uiBottom = 0;
    if (window.visualViewport) {
        const vv = window.visualViewport;
        uiBottom = Math.max(0, window.innerHeight - (vv.height + vv.offsetTop));
    }
    document.documentElement.style.setProperty('--ios-ui-bottom', uiBottom + 'px');

    if (isIOS) {
        const vh = window.innerHeight * 0.01;
        document.documentElement.style.setProperty('--vh', `${vh}px`);

        if (watchVideoSection) {
            watchVideoSection.style.height = 'calc(var(--vh) * 100 - var(--navbar-height))';
        }
    }
};

window.addEventListener('orientationchange', () => {
    setTimeout(updateIosViewport, 100);
});
```

---

#### Change 2: Enable iOS Scroll - Passive Touch Listeners

**File:** `/home/apps/niko-tv/public/js/pages/WatchPage.js` (Lines 195-206)

**Changes:**
- Added `{ passive: true }` flag to touchstart listener

**Before:**
```javascript
watchSection?.addEventListener('touchstart', () => this.showOverlay());
```

**After:**
```javascript
watchSection?.addEventListener('touchstart', (e) => {
    this.showOverlay();
}, { passive: true });
```

**Why:** `passive: true` tells iOS browser we won't call `preventDefault()`, allowing scroll optimization

---

#### Change 3: Enable iOS Scroll - Momentum Scrolling CSS

**File:** `/home/apps/niko-tv/public/css/main.css`

**Part A - Base watch-page container (Line 3353):**
```css
.watch-page {
  /* ... existing properties ... */
  -webkit-overflow-scrolling: touch; /* Added */
}
```

**Part B - Mobile-specific scroll enforcement (Line ~2226):**
```css
@media (max-width: 768px) {
  .page {
    overflow-y: scroll !important;
    -webkit-overflow-scrolling: touch;
  }

  #page-home {
    overflow-y: scroll !important;
    -webkit-overflow-scrolling: touch;
  }

  .watch-page {
    height: calc(100vh - var(--navbar-height));
    height: calc(100dvh - var(--navbar-height));
    overflow-y: scroll !important;
    -webkit-overflow-scrolling: touch;
  }
}
```

**Part C - Landscape orientation scroll fix (Line ~2735):**
```css
@media (max-width: 896px) and (orientation: landscape) {
  .page {
    overflow-y: scroll !important;
    -webkit-overflow-scrolling: touch !important;
  }

  #page-home {
    overflow-y: scroll !important;
    -webkit-overflow-scrolling: touch !important;
  }

  .watch-page {
    overflow-y: scroll !important;
    -webkit-overflow-scrolling: touch !important;
  }

  .watch-video-section {
    max-height: calc(100vh - var(--navbar-height));
    max-height: calc(100dvh - var(--navbar-height));
  }
}
```

**Part D - iPad-specific fixes (Line ~4873):**
```css
@media (min-width: 768px) and (max-width: 1024px) {
  .page {
    overflow-y: scroll;
    -webkit-overflow-scrolling: touch;
  }

  #page-home {
    overflow-y: scroll;
    -webkit-overflow-scrolling: touch;
  }

  .watch-page {
    overflow-y: scroll;
    -webkit-overflow-scrolling: touch;
  }

  .watch-video-section {
    max-height: calc(100vh - var(--navbar-height));
  }
}
```

---

#### Change 4: Apply Same Pattern to Live TV Player

**File:** `/home/apps/niko-tv/public/js/components/VideoPlayer.js` (Lines 160-195)

**Changes:**
- Applied same orientation-aware viewport updates as WatchPage.js
- Ensures consistent behavior across Live TV and VOD players

---

### Phase 3: Additional Debug Logging

**Files Modified:**
- `/home/apps/niko-tv/public/js/pages/WatchPage.js`
- `/home/apps/niko-tv/public/js/components/VideoPlayer.js`

**Debug Logs Added:**
```javascript
console.log('[WatchPage] Orientation changed! Updating viewport in 100ms...');
console.log('[WatchPage] Viewport updated - innerHeight:', window.innerHeight, 'vh:', vh);
console.log('[VideoPlayer] Orientation changed! Updating viewport in 100ms...');
console.log('[VideoPlayer] Viewport updated - innerHeight:', window.innerHeight, 'vh:', vh);
```

**Purpose:** Track orientation changes and viewport recalculations for troubleshooting

---

### Phase 4: Touch-Action CSS Properties

**File:** `/home/apps/niko-tv/public/css/main.css`

**Changes to fix vertical scroll blocking:**

**Mobile Media Query (Line ~2227):**
```css
.page {
  overflow-y: scroll !important;
  -webkit-overflow-scrolling: touch;
  touch-action: pan-y pinch-zoom; /* Added */
}

#page-home {
  overflow-y: scroll !important;
  -webkit-overflow-scrolling: touch;
  touch-action: pan-y pinch-zoom; /* Added */
}
```

**Landscape Orientation (Line ~2735):**
```css
.page {
  overflow-y: scroll !important;
  -webkit-overflow-scrolling: touch !important;
  touch-action: pan-y pinch-zoom !important; /* Added */
}

#page-home {
  overflow-y: scroll !important;
  -webkit-overflow-scrolling: touch !important;
  touch-action: pan-y pinch-zoom !important; /* Added */
}
```

**iPad-Specific (Line ~4873):**
```css
.page {
  overflow-y: scroll;
  -webkit-overflow-scrolling: touch;
  touch-action: pan-y pinch-zoom; /* Added */
}

#page-home {
  overflow-y: scroll;
  -webkit-overflow-scrolling: touch;
  touch-action: pan-y pinch-zoom; /* Added */
}
```

**Home Page Base Container (Line ~4563):**
```css
#page-home {
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  touch-action: pan-y pinch-zoom; /* Added */
}

.dashboard-content {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  touch-action: pan-y pinch-zoom; /* Added */
}
```

**Horizontal Scroll Containers (Line ~4650):**
```css
.horizontal-scroll {
  /* ... existing properties ... */
  touch-action: pan-x; /* Added - only horizontal, let vertical pass through */
}

.scroll-wrapper {
  position: relative;
  touch-action: pan-y; /* Added - allow vertical scroll to pass through */
}
```

**Why:** Separates horizontal and vertical touch gestures. Horizontal scrollers only capture horizontal swipes, allowing vertical scrolling to propagate to parent containers.

---

## Current Status: UNRESOLVED ISSUES

### Issue 1: Home Page Vertical Scroll (iPhone) - ❌ NOT WORKING

**Symptom:**
- Cannot scroll vertically on home page
- Horizontal scroll works (favorite channels, movies, series)
- Vertical scroll blocked

**Attempted Fixes:**
1. Added `-webkit-overflow-scrolling: touch` to `.page` and `#page-home`
2. Added `overflow-y: scroll !important` to force scroll container
3. Added `touch-action: pan-y pinch-zoom` to allow vertical gestures
4. Added `touch-action: pan-x` to horizontal scrollers to separate gesture handling
5. Added `touch-action: pan-y` to `.scroll-wrapper`
6. Added `touch-action: pan-y pinch-zoom` to `.dashboard-content`

**Still Not Working After:**
- Hard refresh (Cmd+Shift+R)
- Safari cache clear via Settings
- Browser restart

**Next Steps to Try:**
- Investigate JavaScript event handlers that may be calling `preventDefault()`
- Check for conflicting CSS properties
- Verify cache is actually cleared (check console for debug logs)
- Test with `touch-action: manipulation` instead of `pan-y`
- Investigate if horizontal scroll containers are blocking parent scroll

---

### Issue 2: iPhone Landscape Video Disappears - ❌ PARTIALLY WORKING

**Current Behavior:**
- Portrait mode: Video now centered on phone (improvement from before)
- Landscape mode: Video picture disappears, only audio plays
- Tapping screen pauses video (controls responding)

**Attempted Fixes:**
1. Added `orientationchange` event listener with 100ms delay
2. Dynamic `--vh` recalculation on orientation change
3. Updated `watchVideoSection.style.height` on every viewport update
4. Added `max-height` constraints to `.watch-video-section`
5. Added console logging to track orientation events

**Diagnostic Questions:**
- Are console logs appearing when rotating? (Would indicate orientation detection working)
- Is `--vh` value updating? (Check in DevTools during rotation)
- Is video element still in DOM during landscape? (Check Elements panel)

**Next Steps to Try:**
- Increase orientation change timeout from 100ms to 300ms
- Force video element redraw/repaint after orientation change
- Check if video container z-index or positioning is off-screen
- Verify `calc(var(--vh) * 100 - var(--navbar-height))` calculates correctly
- Add `position: relative` to video containers

---

### Issue 3: iPad Scrolling - ❓ STATUS UNKNOWN

**User has not tested iPad again since latest fixes**

**Previous Status:**
- Sometimes freezes
- Working in both orientations (with occasional freezes)

**Applied Fixes:**
- iPad-specific media query (768px - 1024px)
- iOS momentum scrolling
- Touch-action properties

---

## Files Modified

### JavaScript Files

1. **`/home/apps/niko-tv/public/js/pages/WatchPage.js`**
   - Lines 100-145: Orientation-aware viewport updates
   - Lines 195-213: Passive touch listener
   - Added debug console logging

2. **`/home/apps/niko-tv/public/js/components/VideoPlayer.js`**
   - Lines 160-200: Orientation-aware viewport updates
   - Added debug console logging

### CSS Files

3. **`/home/apps/niko-tv/public/css/main.css`**
   - Line 3353: Base momentum scrolling on `.watch-page`
   - Lines 2226-2247: Mobile scroll rules (768px breakpoint)
   - Lines 2735-2755: Landscape scroll rules (896px landscape)
   - Lines 4563-4574: Home page base container scroll
   - Lines 4598-4600: Scroll wrapper touch-action
   - Lines 4650-4658: Horizontal scroll touch-action
   - Lines 4873-4895: iPad-specific rules (768px-1024px)

### Backup Files

4. **Created (v1 - Original working state):**
   - `/home/apps/niko-tv/public/js/pages/WatchPage.js.backup.v1`
   - `/home/apps/niko-tv/public/js/components/VideoPlayer.js.backup.v1`
   - `/home/apps/niko-tv/public/css/main.css.backup.v1`

---

## Testing Checklist

### ✅ Working Correctly
- [x] PC/Desktop - All browsers
- [x] iPad landscape video playback (before fixes)
- [x] iPad portrait video playback (before fixes)
- [x] iPhone horizontal scrolling (favorite channels, movies, series)

### ❌ Not Working
- [ ] iPhone vertical scroll on home page (portrait and landscape)
- [ ] iPhone landscape video visibility

### ❓ Unknown Status (Needs Testing)
- [ ] iPad vertical scroll after latest fixes
- [ ] iPad orientation changes without freezing
- [ ] iPhone video in landscape after cache clear
- [ ] Console debug logs appearing on mobile

---

## Cache Clearing Instructions

### iPhone Safari
**Method 1 (Recommended):**
1. Close Safari completely (swipe up from app switcher)
2. Settings → Safari → Clear History and Website Data
3. Tap "Clear History and Data"
4. Reopen Safari and navigate to niko-tv

**Method 2 (Quick):**
1. In Safari, tap 'AA' icon in address bar
2. Tap "Reload Without Content Blockers"

**Method 3 (Hard Refresh):**
1. Pull down on address bar to show refresh button
2. Long-press refresh button → select reload option

### Verification
Check browser console for debug messages:
- `[WatchPage] Orientation changed!`
- `[VideoPlayer] Viewport updated`

If these don't appear, cache hasn't cleared.

---

## Known Issues & Workarounds

### Cache Persistence
**Issue:** iOS Safari aggressively caches JavaScript and CSS
**Workaround:** Add version query parameter: `https://niko-tv-url.com/?v=2`

### Touch Event Conflicts
**Issue:** Horizontal scroll containers may block vertical scroll
**Current Solution:** `touch-action: pan-x` on horizontal scrollers
**Status:** Not fully working yet

### Orientation Detection Timing
**Issue:** 100ms delay may not be enough for browser to complete orientation transition
**Potential Solution:** Increase to 300ms or use `screen.orientation` API

---

## Recommendations for Next Steps

### Immediate Priority: Fix Home Page Scroll

1. **Verify Cache Cleared:**
   - Connect iPhone to Mac
   - Use Safari Developer Tools to check console logs
   - Confirm debug messages appear

2. **Investigate Event Handlers:**
   - Search for `preventDefault()` calls in JavaScript
   - Check if any event handlers are blocking touch events
   - Look for third-party libraries interfering with scroll

3. **Try Alternative CSS:**
   ```css
   #page-home {
     touch-action: manipulation; /* Instead of pan-y pinch-zoom */
   }
   ```

4. **Add Body-Level Touch Action:**
   ```css
   body {
     touch-action: pan-y pinch-zoom;
   }
   ```

### Secondary Priority: Fix Landscape Video

1. **Increase Orientation Timeout:**
   ```javascript
   window.addEventListener('orientationchange', () => {
       setTimeout(updateIosViewport, 300); // Increased from 100ms
   });
   ```

2. **Force Video Redraw:**
   ```javascript
   if (watchVideoSection) {
       watchVideoSection.style.display = 'none';
       watchVideoSection.offsetHeight; // Force reflow
       watchVideoSection.style.display = '';
       watchVideoSection.style.height = 'calc(var(--vh) * 100 - var(--navbar-height))';
   }
   ```

3. **Add Position Constraints:**
   ```css
   .watch-video-section {
     position: relative;
     min-height: 0;
     max-width: 100vw;
   }
   ```

---

## Technical Notes

### iOS Viewport Behavior
- `window.innerHeight` changes during orientation
- `visualViewport.height` accounts for dynamic toolbars
- `100vh` is unreliable on mobile Safari (doesn't account for toolbar)
- Custom `--vh` unit needed for accurate height calculations

### Touch Gesture Handling
- `touch-action: auto` - All gestures allowed (default)
- `touch-action: pan-x` - Only horizontal scrolling
- `touch-action: pan-y` - Only vertical scrolling
- `touch-action: manipulation` - Pan and zoom, no double-tap delay
- `touch-action: none` - No touch gestures

### iOS Momentum Scrolling
- `-webkit-overflow-scrolling: touch` - Enables momentum scrolling
- Only works on containers with `overflow: auto` or `overflow: scroll`
- May conflict with `touch-action` if not set properly

---

## Git Status

**Branch:** main (assumed)
**Last Commit:** (To be updated after this commit)

**Modified Files (Uncommitted):**
- public/js/pages/WatchPage.js
- public/js/components/VideoPlayer.js
- public/css/main.css

**New Files:**
- project-summary.md
- public/js/pages/WatchPage.js.backup.v1
- public/js/components/VideoPlayer.js.backup.v1
- public/css/main.css.backup.v1

---

## Conclusion

Significant work has been done to address iOS mobile issues with orientation changes and scrolling. While the underlying fixes are theoretically sound and follow iOS best practices, they are not yet working as expected on the test devices.

The primary blocker appears to be browser cache persistence, preventing new code from loading on the iPhone. Secondary issues include potential JavaScript event handler conflicts and timing issues with orientation detection.

**Next Session Goals:**
1. Definitively confirm cache is cleared via console logging
2. Systematically test each touch-action configuration
3. If scroll still doesn't work, investigate JavaScript event handlers
4. For landscape video, increase orientation timeout and add forced reflow
5. Create test build with version query parameters to bypass cache
