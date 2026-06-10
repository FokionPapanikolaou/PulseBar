# PulseBar — Analytics Playbook

Where every signal about PulseBar's adoption lives, and how to read it.
This is a private playbook — kept in the repo so it travels with the code.

---

## 📊 The 3 dashboards

### 1. Microsoft Store (Partner Center)
The **source of truth** for paid metrics: acquisitions, installs, ratings,
reviews, crashes, demographics. Updates daily, ~24h delay.

| Report | Direct URL |
|--------|------------|
| Overview | https://partner.microsoft.com/dashboard/insights/analytics/reports |
| **Acquisitions** (installs / day) | https://partner.microsoft.com/dashboard/insights/analytics/acquisitions |
| **Ratings** (stars over time) | https://partner.microsoft.com/dashboard/insights/analytics/ratings |
| **Reviews** (read & respond) | https://partner.microsoft.com/dashboard/insights/analytics/reviews |
| **Health** (crashes & errors) | https://partner.microsoft.com/dashboard/insights/analytics/health |
| Demographics | https://partner.microsoft.com/dashboard/insights/analytics/demographics |
| Channels & conversions | https://partner.microsoft.com/dashboard/insights/analytics/channelsconversions |

**The numbers that matter:**
- **Total acquisitions** → cumulative installs since launch
- **Daily new** → marketing signal (spikes after posts)
- **Conversion rate** → store-page-views / installs (industry avg ~5-15%)
- **Average rating** → if it drops below 4.0★, dig into reviews
- **Crash rate** → should stay under 0.1% to stay "Healthy"

> The Partner Center cleans the data daily and removes test installs (yours).

### 2. GitHub (public, free, instant)
The pulse of the **dev community**: stars, forks, traffic, clone counts,
download attempts of the signed binaries.

```powershell
# Run the dashboard locally (uses gh CLI if available):
powershell -File pulsebar_stats.ps1
```

**The 5 numbers I check first:**
- ⭐ **Stars** = social proof; one weekly check is enough
- 📥 **Release downloads** per asset (`PulseBar-Setup.exe` vs `PulseBar.exe`)
- 👁️ **Traffic / views** (14-day window) = direct interest
- 🔗 **Top referrers** = where new visitors come from (Reddit? HN? a tweet?)
- 📋 **Open issues** = product-quality signal

### 3. Landing site (GitHub Pages)
Quick sanity-check that the public face is up. No first-party analytics —
on purpose, no cookies, no tracking pixels — but availability is monitored
from the stats script.

---

## 🎯 Cadence

| Frequency | What to check | Where |
|-----------|--------------|-------|
| **Daily** (first week) | Acquisitions trend, new reviews | Partner Center |
| **Weekly** | Stars, downloads, top referrers | `pulsebar_stats.ps1` |
| **After every release** | Crash rate, version adoption | Partner Center → Health |
| **After every post** | Spike in traffic + acquisitions | Both |
| **Monthly** | Demographics, top markets | Partner Center |

---

## 🚀 What "good" looks like (rough benchmarks for a free Win utility)

| Phase | Daily acquisitions | Conversion | Avg rating |
|-------|-------------------|-----------|-----------|
| Week 1 (org launch) | 5-50 | 5-10% | n/a (too few) |
| Month 1 | 20-200 | 8-15% | ≥4.2 ★ |
| Month 3 (mature) | 50-500 | 10-20% | ≥4.5 ★ |
| Featured by MS | 500-5000 spike | 15-25% | maintained |

If a post lands well on Reddit / Hacker News, expect a 5-50x daily spike that
decays over 3-7 days.

---

## 🔔 Alerts I should set up later

- **Email** on every new 1-3★ review (Partner Center → Reviews → notification)
- **Webhook** when daily crash rate > 0.5% (Partner Center → Notifications)
- **GitHub watch** for new issues labelled `bug`

---

## 🧭 What I *don't* collect (and won't)

PulseBar has **no in-app telemetry**. Microsoft Store acquisition / crash data is
aggregated by Microsoft and arrives anonymised. GitHub traffic uses GitHub's own
counters. The landing site has no analytics script. The user's PC stays the
user's PC.

This is a deliberate choice — disclosed in [PRIVACY.md](../PRIVACY.md) and
re-stated in every store description.
