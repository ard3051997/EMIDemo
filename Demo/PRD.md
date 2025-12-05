# Product Requirements Document (PRD)
# EMI Calculator App

**Version:** 1.0
**Date:** December 5, 2025
**Product Owner:** IndieBuilderKit Team
**Target Platform:** iOS 17.0+

---

## Executive Summary

EMI Calculator is a comprehensive financial companion app designed for the Indian market, empowering users to make informed loan decisions through EMI calculations, loan comparisons, and access to various financial tools. The app serves 10M+ users with a freemium monetization model combining ads and premium subscriptions.

---

## Product Vision

**Mission:** To democratize financial literacy and empower Indian users to make confident, informed decisions about loans and financial planning through simple, accessible tools.

**Vision Statement:** "Your Financial Companion - Nurturing Your Dreams, Step by Step"

---

## Target Audience

### Primary Users
- **Age:** 25-45 years
- **Demographics:** Working professionals, first-time home buyers, vehicle buyers
- **Income:** Middle to upper-middle class (₹3L-₹20L annual income)
- **Location:** Urban and semi-urban India
- **Tech Savvy:** Moderate (comfortable with smartphone apps)

### User Personas

**Persona 1: The First-Time Home Buyer**
- Name: Rahul, 32
- Needs: Compare home loan options, understand EMI affordability
- Pain Points: Confusion about interest rates, inability to compare multiple banks
- Goals: Find the most affordable loan option for his budget

**Persona 2: The Financial Planner**
- Name: Priya, 28
- Needs: Multiple financial calculators (SIP, FD, RD), investment planning
- Pain Points: Switching between multiple apps for different calculations
- Goals: One-stop solution for all financial calculations

**Persona 3: The Small Business Owner**
- Name: Amit, 40
- Needs: Quick EMI calculations, GST calculator, business loan comparison
- Pain Points: Time-consuming manual calculations
- Goals: Fast, accurate financial planning tools

---

## Core Features & Requirements

### 1. Splash Screen & App Launch

**Requirements:**
- Display app logo (4-quadrant calculator icon in blue)
- Show tagline: "Your EMI Companion"
- Display trust badge: "Trusted by 10M+ users"
- Show "Made in India" badge with heart icon
- Loading animation during app initialization
- Smooth transition to onboarding (first launch) or home screen

**Success Metrics:**
- App launch time < 2 seconds
- Smooth animation at 60 FPS

---

### 2. Onboarding Flow

**Purpose:** Educate new users about key features and value propositions

#### Screen 1: EMI Calculator Introduction
**Content:**
- Headline: "Nurturing Your Dreams, Step by Step"
- Subheading: "Introducing the EMI Calculator! 🚀"
- Visual: iPhone mockup showing EMI calculator interface
- CTA: Blue circular next button, "Skip" option

**Key Information Displayed:**
- Loan Amount input field
- Interest Rate input
- Period selection (Years/Months)
- Calculate and Reset buttons

#### Screen 2: Loan Comparison
**Content:**
- Headline: "Discover Pocket-Friendly Loans"
- Subheading: "Instantly Compare Rates with breakdown! 💸"
- Visual: iPhone mockup showing loan comparison tool
- CTA: Next button, Skip option

**Key Information Displayed:**
- Side-by-side loan comparison
- Monthly EMI difference calculation
- Interest rate comparison

#### Screen 3: Financial News
**Content:**
- Headline: "Become a Finance Guru"
- Subheading: "Stay on Top with Exciting Finance News!"
- Visual: iPhone mockup showing news feed
- CTA: Get Started button

**Key Information Displayed:**
- News article cards with images
- Source attribution
- Read News CTA

**Requirements:**
- Swipeable carousel with dot indicators
- Skip functionality on all screens
- Progress indicators (1 of 3, 2 of 3, 3 of 3)
- Only show once per user (persist completion status)

**Success Metrics:**
- > 60% completion rate
- < 20% skip rate on first screen

---

### 3. EMI Calculator (Core Feature)

**Purpose:** Calculate monthly EMI for various loan types

**Input Fields:**
- **Loan Amount:** Numeric input, ₹ symbol prefix
  - Minimum: ₹10,000
  - Maximum: ₹10,00,00,000 (10 crores)
  - Default: ₹5,00,000

- **Interest Rate:** Percentage input
  - Range: 1% - 50%
  - Decimal support (e.g., 8.5%)
  - Default: 8%

- **Period:** Dual input (Years + Months)
  - Year range: 0-30
  - Month range: 0-11
  - Total minimum: 1 month
  - Total maximum: 30 years
  - Default: 5 years, 0 months

**Output Display:**
- **Monthly EMI:** Prominently displayed in large text
- **Total Interest:** Total interest payable
- **Total Amount:** Principal + Interest
- **Breakdown Chart:** Visual representation (pie/bar chart)
  - Principal amount
  - Interest amount

**Actions:**
- **Calculate Button:** Primary blue button, triggers calculation
- **Reset Button:** Secondary text button, clears all inputs
- **Share EMI Details:** WhatsApp share integration

**Calculation Formula:**
```
EMI = [P x R x (1+R)^N] / [(1+R)^N-1]
where:
P = Principal loan amount
R = Monthly interest rate (annual rate / 12 / 100)
N = Number of monthly installments (years × 12 + months)
```

**Requirements:**
- Real-time validation of inputs
- Error messages for invalid inputs
- Decimal precision for currency (2 decimal places)
- Responsive keyboard with number pad
- Smooth scrolling for long results

**Success Metrics:**
- > 80% daily active users use EMI calculator
- Average 3+ calculations per session

---

### 4. Loan Comparison Tool

**Purpose:** Compare multiple loan offers side-by-side

**Features:**
- Compare 2 loans simultaneously
- Input fields for each loan:
  - Loan Amount
  - Interest Rate (%)
  - Duration (Months)
- Calculate button
- Reset button

**Output Display:**
- Monthly EMI for both loans
- Difference amount (highlighted)
- Difference percentage
- Visual indicator (color coding)
  - Green for better option
  - Red for higher cost
- Interest Payable comparison
- Total Amount comparison

**Additional Features:**
- Save comparison for later
- Share comparison via WhatsApp
- "New" badge to promote feature

**Requirements:**
- Support up to 5 saved comparisons
- Comparison history (last 10 comparisons)
- Export as PDF (premium feature)

**Success Metrics:**
- > 40% users try loan comparison
- Average 2 comparisons per user who tries feature

---

### 5. Financial Tools Suite

**Collection of specialized calculators:**

#### 5.1 FD Calculator (Fixed Deposit)
- **Inputs:** Principal, Interest Rate, Tenure
- **Output:** Maturity Amount, Interest Earned

#### 5.2 SIP Calculator (Systematic Investment Plan)
- **Inputs:** Monthly Investment, Expected Return %, Time Period
- **Output:** Total Investment, Expected Returns, Maturity Value

#### 5.3 RD Calculator (Recurring Deposit)
- **Inputs:** Monthly Deposit, Interest Rate, Tenure
- **Output:** Maturity Amount, Total Deposit, Interest Earned

#### 5.4 Currency Converter
- **Inputs:** Amount, From Currency, To Currency
- **Output:** Converted Amount
- **Features:** Real-time exchange rates (API integration)
- **Supported Currencies:** USD, EUR, GBP, INR, AED, SGD, JPY, CNY

#### 5.5 GST Calculator
- **Modes:**
  - Add GST to amount
  - Remove GST from amount
- **Inputs:** Amount, GST Rate (5%, 12%, 18%, 28%, custom)
- **Output:** GST Amount, Total Amount / Net Amount

#### 5.6 PPF Calculator (Public Provident Fund)
- **Inputs:** Yearly Investment, Time Period, Interest Rate
- **Output:** Maturity Amount, Total Investment, Interest Earned

**Display Requirements:**
- List view with icons
- Search/filter functionality
- Recently used tools at top
- "See all" / "See less" toggle for expandable list

**Success Metrics:**
- > 50% users explore at least one additional tool
- SIP and FD calculators have highest engagement

---

### 6. Location-Based Services

#### 6.1 ATM Finder
- **Purpose:** Find nearest ATMs by bank or location
- **Features:**
  - Map integration (Apple Maps)
  - List view with distance
  - Filter by bank
  - Navigation integration
  - 24/7 availability indicator

#### 6.2 Bank Finder
- **Purpose:** Locate bank branches
- **Features:**
  - Search by bank name
  - Filter by services (home loan, personal loan, etc.)
  - Working hours display
  - Contact details
  - Navigation integration

#### 6.3 Finance Places
- **Purpose:** Discover financial service locations
- **Includes:**
  - NBFCs
  - Financial advisors
  - Insurance offices
  - Stock brokerages

**Ad Monetization:**
- Full-screen video ad before accessing location services (free tier)
- "Watch ad to unlock" modal
- Skip after 5 seconds
- Premium users: No ads

**Requirements:**
- Location permission handling
- Fallback for denied permissions (city selection)
- Offline map caching (premium)
- Distance calculation in km

**Success Metrics:**
- > 30% users try at least one location service
- ATM Finder most used

---

### 7. Financial News & Articles

**Purpose:** Keep users informed about latest financial news

**Features:**
- Curated news articles
- Categories: Banking, Loans, Investments, Economy, GST, Taxes
- Article cards with:
  - Featured image
  - Headline (2-line truncation)
  - Publication date
  - Source name (Zee News, etc.)
  - "Read News" CTA

**Content Sources:**
- RSS feeds from financial news sources
- Partner content
- Curated articles

**Display:**
- Vertical scroll feed
- "View More Articles" link
- Last 4 articles visible initially
- Infinite scroll / Load more

**Requirements:**
- Refresh on pull-to-refresh
- Cache articles for offline reading
- Mark as read functionality
- Share article functionality

**Success Metrics:**
- > 25% users read at least one article
- Average time spent: 2+ minutes
- Daily active readers: 15%

---

### 8. Loan Partners Section

**Purpose:** Promote partner banks and NBFCs for loan offers

**Features:**
- Horizontal scroll carousel
- Partner cards with:
  - Bank/NBFC logo
  - Special offer text
  - Interest rate highlight
  - "Apply Now" CTA

**Partners:**
- Minimum 10 partner institutions
- Mix of banks and NBFCs

**Monetization:**
- CPA (Cost Per Acquisition) model
- Affiliate commissions on successful loan applications
- Featured partner placements (paid)

**Requirements:**
- Track clicks (analytics)
- Track applications (attribution)
- Deep linking to partner apps/websites
- "See all" partners page

**Success Metrics:**
- > 10% click-through rate
- 2% application rate from clicks

---

### 9. Premium Features & Monetization

#### Free Tier Features:
- Basic EMI calculator
- Loan comparison (limited to 2 loans)
- Limited financial tools access
- Ads displayed throughout app
- Location services with video ads
- Watermark on shared PDFs

#### Premium Subscription (₹115/month or ₹300/year):

**Benefits:**
- ✓ Ads-free experience
- ✓ Remove watermark from Invoice/PDF exports
- ✓ Create unlimited invoices (if invoice feature exists)
- ✓ Unlimited loan comparisons
- ✓ Advanced calculators
- ✓ Offline access to all tools
- ✓ Priority customer support
- ✓ Export all calculations as PDF

**Free Alternative:**
- Watch video ad for 1-day ads-free experience
- Rewarded video ads (30 seconds)
- "Watch Now" CTA button

**Pricing:**
- **Monthly:** ₹115/month (₹150 ₹115, save 40%)
- **Yearly:** ₹300/year (save 80% badge)
- Free trial: 7 days (optional)

**Payment Integration:**
- RevenueCat for subscription management
- Apple In-App Purchases
- Auto-renewable subscriptions

**Success Metrics:**
- 5% conversion rate (free to premium)
- 70% monthly retention rate
- 85% annual retention rate

---

### 10. Other Apps Cross-Promotion

**Purpose:** Promote other apps from the same developer

**Featured Apps:**
1. EMI Calculator (current app)
2. GST Calculator
3. Hindi English Translator

**Display:**
- App icon (50x50 pts)
- App name (2 lines max)
- Grid layout (3 columns)
- "View More Apps" link to App Store developer page

**Requirements:**
- Deep links to App Store
- Track install attribution
- A/B test positioning

**Success Metrics:**
- 5% cross-install rate

---

### 11. Social Sharing Features

**Share Options:**
- WhatsApp (primary)
- Other apps via iOS Share Sheet

**Shareable Content:**
- EMI calculation results
- Loan comparison results
- App recommendation

**Share Message Template:**
```
💰 EMI Calculator Results
Loan Amount: ₹5,00,000
Interest Rate: 8.5%
Tenure: 5 years
Monthly EMI: ₹10,251

Total Interest: ₹1,15,060
Total Amount: ₹6,15,060

Download EMI Calculator: [App Store Link]
```

**Incentives:**
- "Help friends in calculating EMI by sharing" prompt
- Social proof messaging
- Referral bonus (future feature)

**Success Metrics:**
- 15% share rate per calculation
- 30% of shares result in app installs

---

### 12. User Interface & Navigation

#### Bottom Navigation Bar (4 tabs):

1. **Home Tab**
   - Icon: House
   - Label: "Home"
   - Default selected

2. **EMI Calculator Tab**
   - Icon: Calculator
   - Label: "EMI Calculator"

3. **Compare Loans Tab**
   - Icon: Comparison chart
   - Label: "Compare Loans"
   - "New" badge

4. **EMI Reminder Tab** (Future Feature)
   - Icon: Bell/Calendar
   - Label: "EMI Reminder"

**Top Navigation:**
- App title or section title
- Back button (contextual)
- Menu icon (hamburger) - leads to settings
- Notification bell with badge count
- Settings/Profile icon

**Requirements:**
- Persistent bottom nav across all main screens
- Active state indicator (blue highlight)
- Haptic feedback on tab switch
- Smooth transitions

---

### 13. Settings & Preferences

**Account Settings:**
- Name (optional)
- Email (optional)
- Phone number (optional)

**App Preferences:**
- Default currency
- Language selection (English, Hindi)
- Notifications toggle
- Dark mode toggle (future)

**About Section:**
- App version
- Privacy Policy
- Terms of Service
- Rate Us (App Store link)
- Contact Support
- FAQ

**Data Management:**
- Clear cache
- Delete saved calculations
- Export data (premium)

**Requirements:**
- Persist settings locally (UserDefaults)
- Sync settings to cloud (iCloud, premium feature)

---

### 14. Notifications

**Types:**

1. **EMI Reminders** (Future Feature)
   - Scheduled local notifications
   - Remind before due date (1 day, 3 days, 7 days)
   - Customizable timing

2. **News Updates**
   - Push notifications for breaking financial news
   - Opt-in during onboarding
   - Daily digest option

3. **Promotional**
   - Premium subscription offers
   - New feature announcements
   - Partner loan offers
   - Limit: Max 1 per week

**Requirements:**
- Request notification permission during onboarding
- Easy opt-out in settings
- Delivery window: 10 AM - 8 PM IST
- Localized notifications

**Success Metrics:**
- 50% notification opt-in rate
- 20% notification open rate

---

## Technical Requirements

### Platform & Compatibility
- **iOS Version:** 17.0+
- **Devices:** iPhone, iPad
- **Orientations:** Portrait (primary), Landscape (optional for iPad)
- **Screen Sizes:** Support all iPhone sizes from SE to Pro Max

### Performance Requirements
- **App Launch:** < 2 seconds (cold start)
- **Screen Transitions:** 60 FPS, < 300ms
- **API Calls:** < 2 seconds response time
- **Offline Support:** Core calculators work offline
- **App Size:** < 50 MB download

### Data & Privacy
- **Data Collection:**
  - Calculation history (local)
  - User preferences (local)
  - Analytics (anonymized)
  - Crash reports

- **Privacy Compliance:**
  - No PII collection without consent
  - GDPR compliant
  - Clear privacy policy
  - Data deletion on request

- **Security:**
  - HTTPS for all API calls
  - Secure storage for sensitive data (Keychain)
  - No storage of financial credentials

### Third-Party Integrations
- **RevenueCat:** Subscription management
- **Firebase:** Analytics, Crashlytics, Remote Config
- **MapKit:** Location services, maps
- **AdMob/Unity Ads:** Ad monetization
- **News API:** Financial news feed
- **Exchange Rate API:** Currency conversion

### Accessibility
- **VoiceOver:** Full support
- **Dynamic Type:** Support all text sizes
- **Color Contrast:** WCAG AA compliant
- **Keyboard Navigation:** Full support (iPad)
- **Localization:** English, Hindi (Phase 1)

---

## Success Metrics & KPIs

### Engagement Metrics
- **DAU (Daily Active Users):** Target 30% of MAU
- **MAU (Monthly Active Users):** Target 50% of installs
- **Session Length:** Target 4 minutes average
- **Sessions per User:** Target 3 per week
- **Retention:**
  - Day 1: > 40%
  - Day 7: > 20%
  - Day 30: > 10%

### Monetization Metrics
- **ARPU (Average Revenue Per User):** ₹15/month
- **Premium Conversion Rate:** 5%
- **Ad Revenue per User (Free Tier):** ₹8/month
- **Churn Rate:** < 30% monthly

### Feature Adoption
- **EMI Calculator Usage:** > 80% of users
- **Loan Comparison:** > 40% of users
- **Financial Tools:** > 50% try at least one tool
- **Location Services:** > 30% of users
- **News Reading:** > 25% of users

### Acquisition Metrics
- **Organic Installs:** 70%
- **Paid Installs:** 20%
- **Referral Installs:** 10%
- **Cost Per Install:** < ₹50
- **App Store Rating:** > 4.5 stars

---

## Development Phases

### Phase 1: MVP (Months 1-2)
**Core Features:**
- Splash screen & onboarding
- EMI calculator (basic)
- Loan comparison (2 loans)
- 3 financial tools (FD, SIP, PPF)
- Home screen with navigation
- Basic settings
- Ad integration
- Analytics

**Goal:** Launch on App Store

### Phase 2: Growth (Months 3-4)
**Features:**
- Premium subscription
- All financial tools
- News section
- Location services
- WhatsApp sharing
- Improved UI/UX
- Performance optimization

**Goal:** 100K installs, 2% conversion rate

### Phase 3: Retention (Months 5-6)
**Features:**
- EMI reminders
- Push notifications
- Advanced loan comparison
- Invoice/PDF export
- Partner integrations
- Referral program
- Hindi localization

**Goal:** 40% Day-7 retention, 5% conversion rate

### Phase 4: Scale (Months 7+)
**Features:**
- Advanced analytics dashboard
- Personalized recommendations
- Chat support
- Credit score integration
- Loan application process
- More languages
- iPad optimization

**Goal:** 1M+ installs, ₹50L+ monthly revenue

---

## Risks & Mitigations

### Risk 1: User Acquisition Cost
**Mitigation:**
- Focus on ASO (App Store Optimization)
- Organic social media marketing
- Referral program
- Content marketing (financial blogs)

### Risk 2: Premium Conversion Rate
**Mitigation:**
- 7-day free trial
- Feature gating (value demonstration)
- Personalized offers
- Abandoned cart emails (premium signup)

### Risk 3: Ad Revenue Decline
**Mitigation:**
- Multiple ad networks
- Rewarded video ads
- Native ads integration
- Optimize ad placements

### Risk 4: Competition
**Mitigation:**
- Unique features (loan comparison, location services)
- Superior UX
- Faster performance
- Localization (Hindi, regional languages)
- Community building

### Risk 5: Technical Debt
**Mitigation:**
- Code reviews
- Automated testing
- Continuous refactoring
- Documentation
- Architecture planning

---

## Appendix

### A. Competitive Analysis

**Competitor 1: EMI Calculator India**
- Strengths: Established user base, simple UI
- Weaknesses: Limited features, poor UX, many ads
- Our Advantage: More features, better UX, cleaner ads

**Competitor 2: Bank EMI Calculator**
- Strengths: Bank trust, accurate calculations
- Weaknesses: Limited to one bank, no comparison
- Our Advantage: Multi-bank comparison, neutral platform

**Competitor 3: Financial Tools Suite**
- Strengths: Many calculators
- Weaknesses: Complex UI, no loan focus
- Our Advantage: Focused on loans, simpler UX

### B. User Research Insights

**Key Findings:**
- Users want quick calculations without signup
- Loan comparison is a major pain point
- Trust is crucial (hence "Made in India" badge)
- Users prefer fewer ads over complex pricing
- WhatsApp sharing is essential in Indian market

**User Quotes:**
- "I need to compare loans from 3-4 banks before deciding"
- "Too many apps have annoying ads"
- "I want to share results with my family"
- "Simple EMI calculator is all I need 90% of the time"

### C. Design System Reference

See CLAUDE.md for detailed design system documentation.

### D. Analytics Events to Track

**User Actions:**
- `app_launched`
- `onboarding_started`, `onboarding_completed`, `onboarding_skipped`
- `emi_calculated`, `loan_compared`
- `tool_opened`, `tool_calculated`
- `news_article_opened`, `news_article_read`
- `premium_viewed`, `premium_purchased`, `premium_cancelled`
- `location_service_used`, `ad_watched`
- `share_initiated`, `share_completed`

**User Properties:**
- `user_type` (free/premium)
- `install_source`
- `language`
- `first_calculation_date`
- `total_calculations`

---

## Conclusion

EMI Calculator is positioned to become the go-to financial companion for Indian users seeking loan information and financial planning tools. With a clear freemium monetization strategy, strong feature set, and focus on user experience, the app targets 1M+ installs and sustainable revenue within the first year.

**Next Steps:**
1. Finalize designs in Figma
2. Begin development sprint planning
3. Set up analytics and monitoring
4. Create marketing plan
5. Prepare App Store assets

---

**Document Owner:** IndieBuilderKit Team
**Last Updated:** December 5, 2025
**Status:** Draft v1.0
