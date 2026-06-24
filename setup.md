# Consultancy CRM SaaS

A modern Student Management and Counselling CRM built with **Astro + Supabase**, deployed on **Cloudflare Pages**.

---

# Tech Stack

* Frontend: Astro
* Styling: TailwindCSS
* Authentication: Supabase Google OAuth
* Database: PostgreSQL (Supabase)
* Storage: Supabase Storage
* Hosting: Cloudflare Pages
* Charts: Chart.js

---

# User Roles

## Admin

* Full access
* Manage staff
* View all students
* Export CSV
* Dashboard analytics

## Counsellor

* Add students
* Add counselling records
* Manage follow-ups

## Staff

* View assigned students
* Update status

---

# Features

## Student Management

Store:

* Name
* Mobile Number
* Date of Birth
* Address
* Guardian Number
* Marks
* Attendance
* Date of Join

---

## Counselling Management

Store:

* DOB
* Referer Name
* Joining Date
* GPA
* Permanent Address
* Temporary Address
* City Choice
* Job Included or Not
* Qualification (+2 / Bachelor)
* Passed Year
* Visa Type
* Contact Number
* Remarks

---

## Dashboard

Display:

* Total Students
* New Leads
* Applied Students
* Visa Approved
* Today's Follow-ups
* Pending Documents

Charts:

* Monthly Student Growth
* Visa Success Rate
* Lead Source Analytics

---

# Pages

## Public

```
/
login
pricing
contact
```

## Protected

```
/overview

/students
/students/new
/students/[id]

/counselling


/settings
```

---

# Database Structure

## profiles

```sql
id UUID PRIMARY KEY
email TEXT
full_name TEXT
role TEXT
branch TEXT
created_at TIMESTAMP
```

---

## students

```sql
id UUID PRIMARY KEY

name TEXT
mobile TEXT
dob DATE
address TEXT

guardian_number TEXT

marks TEXT

attendance INTEGER

join_date DATE

status TEXT

created_by UUID

created_at TIMESTAMP
```

Status:

```
lead
documents_pending
applied
coe_received
visa_approved
joined
```

---

## counselling

```sql
id UUID PRIMARY KEY

student_id UUID

referer_name TEXT

gpa TEXT

permanent_address TEXT

temporary_address TEXT

city_choice TEXT

job_included BOOLEAN

qualification TEXT

passed_year INTEGER

visa_type TEXT

contact_number TEXT

remarks TEXT

created_at TIMESTAMP
```

---

## followups

```sql
id UUID PRIMARY KEY

student_id UUID

next_date DATE

note TEXT

status TEXT
```

Status:

```
pending
completed
missed
```

---

## documents

```sql
id UUID PRIMARY KEY

student_id UUID

type TEXT

file_url TEXT

created_at TIMESTAMP
```

Types:

```
passport
resume
transcript
photo
visa
other
```

---

# Lead Sources

Track where students came from:

```
Facebook
TikTok
Website
Instagram
Walk-In
Friend Referral
```

This helps understand which source brings the most students.

---

# Student Journey

```
Inquiry
↓
Counselling
↓
Documents Collection
↓
Applied
↓
Interview
↓
COE Received
↓
Visa Applied
↓
Visa Approved
↓
Arrived in Japan
```

---

# Folder Structure

```
src/

├── pages/
│
├── index.astro
├── login.astro
│
├── overview.astro
│
├── students/
│     index.astro
│     new.astro
│     [id].astro
│
├── counselling/
│     index.astro
│
├── followups/
│     index.astro
│
├── calendar/
│     index.astro
│
├── settings/
│     index.astro
│
├── layouts/
│
├── components/
│     Sidebar.astro
│     Header.astro
│     DashboardCards.astro
│     StudentTable.astro
│
├── lib/
│     supabase.ts
│     auth.ts
│
├── middleware.ts
│
└── types/
      student.ts
      counselling.ts
```

---

# Phase 1 (MVP)

### Core Features

* Google Login
* Dashboard
* Student Management
* Counselling Form
* Search Students
* Student Profile Page
* Follow-up System
* File Uploads
* CSV Export

Target:

Launch within 1-2 weeks.

---

# Phase 2

### Application Tracking

Progress stages:

```
Inquiry
Counselling
Documents
Applied
Interview
COE
Visa Approved
Arrived
```

---

# Phase 3

### Calendar

Track:

* Follow-ups
* Interview Dates
* Visa Dates
* COE Dates

---

# Phase 4

### Multi-Branch Support

Examples:

```
Kathmandu
Pokhara
Chitwan
Tokyo
Osaka
```

Users can only see their own branch.

---

# Phase 5

### Notifications

* Email reminders
* WhatsApp reminders
* SMS notifications

---

# Phase 6

### AI Features

Generate:

* Counselling Notes
* Student Summaries
* Document Checklists
* Visa Eligibility Suggestions

---

# Pricing Plan

## Starter

NPR 999/month

* 2 Staff
* 500 Students

---

## Professional

NPR 2,999/month

* 10 Staff
* Unlimited Students

---

## Enterprise

Custom Pricing

* Multi Branch
* Unlimited Staff
* Priority Support

---

# Deployment

Frontend:

Cloudflare Pages

Backend:

Supabase

Storage:

Supabase Storage

Authentication:

Supabase Google OAuth

Database:

Supabase PostgreSQL

---

# Goal

Build a simple CRM for education consultancies that replaces Excel sheets and paper records, and later evolve it into a complete SaaS platform for visa, student, and counselling management.
