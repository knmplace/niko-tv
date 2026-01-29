# Manual Deploy Button - Monitoring Dashboard

## 🎉 Feature Added!

You can now deploy Niko TV changes directly from the monitoring dashboard with a single click!

---

## How to Use

### Step 1: Navigate to Niko TV Project
1. Open monitoring dashboard: http://localhost:5005
2. Click on **"Niko TV (Docker)"** project

### Step 2: Deploy Changes
1. Scroll to the **"Manual Deployment"** section
2. Click the **"Deploy Now"** button

### What Happens When You Deploy

The deployment button triggers `/home/apps/niko-tv/deploy.sh` which:

1. ✅ Commits any local changes to git (if present)
2. ✅ Pushes changes to GitHub
3. ✅ Pulls latest code on remote server (192.168.1.221)
4. ✅ Rebuilds Docker containers (`docker compose up -d --build`)
5. ✅ Verifies deployment and shows VPN status

---

## Deployment Output

After clicking "Deploy Now", you'll see:

### Success ✅
- Green success message
- Full deployment log output
- VPN status confirmation
- Deployment logs automatically updated

### Failure ❌
- Red error message
- Error details
- Deployment output (if any)

---

## Workflow Example

### Making Changes to Niko TV

**Option 1: Make changes locally (on this server)**
```bash
cd /home/apps/niko-tv
# Edit files, make changes
# No need to commit manually
```

Then go to monitoring dashboard and click **"Deploy Now"**

**Option 2: Push changes to GitHub from elsewhere**
```bash
# From your development machine
git commit -m "Update feature"
git push origin main
```

Then go to monitoring dashboard and click **"Deploy Now"**

---

## Manual Deployment vs Webhook

| Feature | Manual Deploy Button | Webhook Automation |
|---------|---------------------|-------------------|
| **Trigger** | Click button in dashboard | Push to GitHub branch |
| **Control** | Full manual control | Automatic |
| **Setup** | ✅ Ready now | Requires webhook server setup |
| **Best For** | Controlled deployments | Continuous deployment |

---

## Comparison with Demosite

### Demosite (Webhook Automation)
- Webhook server on port 9000
- Auto-deploys when you push to `firebase` branch
- No manual intervention needed

### Niko TV (Manual Deploy Button)
- No webhook server needed
- Deploy when YOU want
- Full control over deployment timing
- Same deploy script, different trigger

---

## Security

- ✅ **Admin-only**: Requires Firebase authentication
- ✅ **Audit logging**: All deployments are logged
- ✅ **Timeout protection**: 5-minute maximum deployment time
- ✅ **Error handling**: Failed deployments show errors without crashing

---

## Viewing Deployment Logs

### From Monitoring Dashboard
1. Go to Niko TV project page
2. Click **"Deployment Log"** button in the Logs section
3. View last 100 lines of deployment history

### From Command Line
```bash
cd /home/apps/niko-tv
tail -f logs/deployment.log
```

---

## API Endpoint

The deploy button calls:
```
POST /api/projects/niko-tv/deploy
Authorization: Bearer <firebase-id-token>
```

Response:
```json
{
  "success": true,
  "message": "Deployment for Niko TV (Docker) completed successfully",
  "output": "... full deployment output ...",
  "errors": null
}
```

---

## Testing the Feature

1. Open monitoring dashboard: http://localhost:5005
2. Navigate to Niko TV project
3. You should see a new **"Manual Deployment"** section with a blue **"Deploy Now"** button
4. Click it to test!

---

## Troubleshooting

### Button is grayed out or not responding
- Check that you're logged in to the monitoring dashboard
- Check browser console for errors

### Deployment fails
- Check deployment logs: `/home/apps/niko-tv/logs/deployment.log`
- Verify SSH key works: `ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221`
- Verify deploy.sh is executable: `chmod +x /home/apps/niko-tv/deploy.sh`

### No output shown
- Deployment might be running (5-minute timeout)
- Check deployment logs manually
- Refresh the page and try again

---

## Files Modified

### API Endpoint
- `/home/apps/monitoring/app/api/projects/[id]/deploy/route.ts`

### UI Component
- `/home/apps/monitoring/app/projects/[id]/page.tsx`

### Deployment Script
- `/home/apps/niko-tv/deploy.sh` (already existed, now callable from dashboard)

---

## Benefits

✅ **One-click deployment** - No need to SSH or run commands
✅ **Real-time feedback** - See deployment progress and results
✅ **Centralized management** - All projects in one dashboard
✅ **Audit trail** - Every deployment is logged
✅ **Safe and controlled** - Manual approval before each deploy
✅ **Works from anywhere** - Access dashboard from any device

---

**Status:** ✅ Ready to use!
**URL:** http://localhost:5005 → Navigate to "Niko TV (Docker)"
