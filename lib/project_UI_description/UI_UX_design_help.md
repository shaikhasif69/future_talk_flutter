# 🎨 **Future Talk Design System - Complete Guide**

## 🌿 **Color Palette: "Introvert's Haven"**

### **Primary Colors - The Foundation**
- **Sage Green** (`#87A96B`) - Growth, calm, natural comfort
  - **Usage**: Primary buttons, active states, navigation highlights, progress bars
  - **Accessibility**: AA compliant on white backgrounds
  - **Hover state**: `#7A9761` (10% darker)
  - **Light variant**: `#A4B88A` (for backgrounds, subtle highlights)
  - **Psychology**: Evokes nature, growth, and peaceful energy

- **Warm Cream** (`#F7F5F3`) - Gentle on eyes, welcoming background
  - **Usage**: Main backgrounds, card backgrounds, input field backgrounds
  - **Pairs with**: All text colors, excellent base for layering
  - **Alternative**: `#FAF8F6` (slightly warmer for variety)
  - **Psychology**: Creates warmth without harshness of pure white

- **Soft Charcoal** (`#4A4A4A`) - Readable text without harsh black
  - **Usage**: Primary text, headers, important information
  - **Contrast ratio**: 9.74:1 on warm cream (AAA compliant)
  - **Light variant**: `#6B6B6B` (for secondary text)
  - **Psychology**: Authoritative yet gentle, never intimidating

### **Secondary/Accent Colors - Emotional Palette**
- **Dusty Rose** (`#D4A5A5`) - Gentle warmth for important actions
  - **Usage**: Delete actions, urgent notifications, love/heart features, time-sensitive elements
  - **Hover state**: `#C79999`
  - **Light background**: `#F2E6E6` (for error states, important backgrounds)
  - **Psychology**: Urgent without being alarming, warm rather than aggressive

- **Lavender Mist** (`#C8B5D1`) - Creativity, premium features
  - **Usage**: Premium badges, creative features, special moments, magic elements
  - **Hover state**: `#BCA8C7`
  - **Light background**: `#E8DFF0` (for premium feature backgrounds)
  - **Gradient pair**: Works beautifully with sage green for premium gradients

- **Warm Peach** (`#F4C2A1`) - Comfort, positive feedback
  - **Usage**: Success messages, achievement celebrations, comfort features, positive notifications
  - **Hover state**: `#F0B894`
  - **Light background**: `#FBE8DC` (for success states)
  - **Psychology**: Celebrates without overwhelming, gentle positivity

- **Cloud Blue** (`#B8D4E3`) - Trust, communication elements
  - **Usage**: Information states, communication indicators, trust badges, calm features
  - **Hover state**: `#A8C8D9`
  - **Light background**: `#E4F1F7` (for info backgrounds)
  - **Psychology**: Trustworthy, calm, reliable communication

### **Neutral Palette - Foundation & Structure**
- **Pearl White** (`#FEFEFE`) - Clean backgrounds
  - **Usage**: Modal backgrounds, overlay backgrounds, pure clean areas
  - **When to use**: When warm cream feels too warm, for maximum contrast

- **Whisper Gray** (`#F0F0F0`) - Subtle separators
  - **Usage**: Divider lines, subtle borders, disabled states
  - **Variants**: `#E8E8E8` (slightly darker for more definition)

- **Stone Gray** (`#D1D1D1`) - Inactive elements
  - **Usage**: Disabled buttons, inactive tabs, placeholder text
  - **Darker variant**: `#BFBFBF` (for more prominent inactive states)

## 🔮 **Component Design Language**

### **Shape Philosophy: "Organic Comfort"**

#### **Border Radius System**
- **Cards & Containers**: 16px (creates intimate, cozy feeling)
- **Buttons**: 12px (friendly but not too round)
- **Input Fields**: 8px (subtle, professional)
- **Small Elements**: 6px (badges, tags, small buttons)
- **Large Features**: 20px (hero cards, main feature blocks)
- **Circular Elements**: 50% (avatars, floating action buttons)

#### **Shadow System - "Gentle Elevation"**
```css
/* Level 1 - Subtle presence */
box-shadow: 0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.12);

/* Level 2 - Card elevation */
box-shadow: 0 3px 6px rgba(0,0,0,0.08), 0 3px 6px rgba(0,0,0,0.12);

/* Level 3 - Modal/floating elements */
box-shadow: 0 6px 12px rgba(0,0,0,0.08), 0 8px 24px rgba(0,0,0,0.12);

/* Level 4 - Maximum elevation (rare use) */
box-shadow: 0 12px 24px rgba(0,0,0,0.08), 0 16px 48px rgba(0,0,0,0.12);
```

#### **Spacing System - "Breathing Room"**
- **Micro**: 4px (icon padding, small adjustments)
- **Small**: 8px (button padding, small gaps)
- **Medium**: 16px (standard padding, element spacing)
- **Large**: 24px (section spacing, card padding)
- **Extra Large**: 32px (major section breaks)
- **Huge**: 48px (screen-level spacing, hero sections)

### **Typography Hierarchy - "Friendly Authority"**

#### **Font Families**
- **Primary**: Inter or Poppins (headers, UI elements)
  - **Weights**: 400 (regular), 500 (medium), 600 (semi-bold)
  - **Character**: Clean, trustworthy, modern but warm
- **Secondary**: Nunito Sans (body text, personal content)
  - **Weights**: 400 (regular), 500 (medium)
  - **Character**: Slightly more personality, feels handwritten but clean

#### **Type Scale**
- **H1**: 32px/40px, Semi-bold (600) - Page titles, major headers
- **H2**: 24px/32px, Medium (500) - Section headers
- **H3**: 20px/28px, Medium (500) - Subsection headers
- **H4**: 18px/24px, Medium (500) - Card titles
- **Body Large**: 16px/24px, Regular (400) - Main body text
- **Body**: 14px/20px, Regular (400) - Secondary body text
- **Caption**: 12px/16px, Regular (400) - Metadata, timestamps
- **Button Text**: 14px/20px, Medium (500) - All button text
- **Small**: 10px/16px, Regular (400) - Fine print, legal text

#### **Text Color Usage**
- **Primary text**: Soft Charcoal (`#4A4A4A`) - Main content
- **Secondary text**: `#6B6B6B` - Supporting information
- **Disabled text**: Stone Gray (`#D1D1D1`) - Inactive states
- **Link text**: Sage Green (`#87A96B`) - Interactive text
- **Error text**: Dusty Rose (`#D4A5A5`) - Error messages
- **Success text**: `#7A9761` (darker sage) - Success messages

### **Interactive Elements - "Gentle Responsiveness"**

#### **Button System**
```css
/* Primary Button */
background: linear-gradient(135deg, #87A96B, #7A9761);
border-radius: 12px;
padding: 12px 24px;
font-size: 14px;
font-weight: 500;
transition: all 200ms ease-out;
box-shadow: 0 2px 4px rgba(135, 169, 107, 0.2);

/* Hover State */
transform: translateY(-1px);
box-shadow: 0 4px 8px rgba(135, 169, 107, 0.3);

/* Secondary Button */
background: #F7F5F3;
border: 1px solid #E0E0E0;
color: #4A4A4A;
```

#### **Input Field System**
```css
/* Standard Input */
background: #FEFEFE;
border: 1px solid #E0E0E0;
border-radius: 8px;
padding: 12px 16px;
font-size: 16px;
transition: all 200ms ease-out;

/* Focus State */
border-color: #87A96B;
box-shadow: 0 0 0 3px rgba(135, 169, 107, 0.1);
outline: none;

/* Error State */
border-color: #D4A5A5;
box-shadow: 0 0 0 3px rgba(212, 165, 165, 0.1);
```

#### **Card System**
```css
/* Standard Card */
background: #F7F5F3;
border-radius: 16px;
padding: 24px;
box-shadow: 0 3px 6px rgba(0,0,0,0.08);
transition: all 200ms ease-out;

/* Hover State */
transform: translateY(-2px);
box-shadow: 0 6px 12px rgba(0,0,0,0.12);

/* Interactive Card */
cursor: pointer;
border: 1px solid transparent;

/* Interactive Card Hover */
border-color: #87A96B;
```

### **Icon System - "Rounded Friendliness"**
- **Style**: Rounded line icons (2px stroke width)
- **Sizes**: 16px (small), 20px (medium), 24px (large), 32px (extra large)
- **Color**: Inherits from parent or uses secondary text color
- **Hover states**: Slight scale (1.05x) with color change to sage green
- **Library recommendation**: Lucide React, Phosphor Icons, or custom rounded versions

### **Animation Principles - "Gentle Life"**
- **Duration**: 200ms (micro), 300ms (standard), 500ms (complex)
- **Easing**: ease-out (feels natural), cubic-bezier(0.25, 0.46, 0.45, 0.94)
- **Hover effects**: Subtle lift (2-4px translateY), gentle scale (1.02-1.05x)
- **Loading states**: Gentle pulse, breathing animations
- **Transitions**: Focus on opacity and transform, avoid jarring layout shifts

### **State Management - "Visual Feedback"**
- **Loading**: Gentle pulse animation with sage green tint
- **Success**: Brief warm peach background flash
- **Error**: Subtle dusty rose border with gentle shake
- **Disabled**: Reduced opacity (0.6) with stone gray overlay
- **Focus**: Soft glow effect with primary color
- **Active**: Slightly darker background with subtle inner shadow

### **Accessibility Standards**
- **Contrast ratios**: Minimum AA (4.5:1), prefer AAA (7:1)
- **Touch targets**: Minimum 44px (iOS) / 48dp (Android)
- **Font sizes**: Minimum 14px for body text, 12px for captions
- **Color dependence**: Never rely solely on color for important information
- **Animation**: Respect prefers-reduced-motion settings

### **Responsive Breakpoints**
- **Mobile**: 0-767px (primary focus)
- **Tablet**: 768-1023px (secondary)
- **Desktop**: 1024px+ (tertiary, mainly web version)

### **Component Variants by Context**
#### **Comfort Level Contexts**
- **High energy** (green battery): Brighter colors, more animations
- **Medium energy** (yellow): Softer colors, reduced animations
- **Low energy** (red): Muted colors, minimal animations, larger touch targets

#### **Time-of-Day Adaptations**
- **Morning** (6-12): Fresher, brighter variants
- **Afternoon** (12-18): Standard palette
- **Evening** (18-22): Warmer, softer variants
- **Night** (22-6): Darker, muted variants (optional dark mode preparation)

## 🎯 **Implementation Guidelines**

### **Do's**
- Always use the spacing system (multiples of 4px)
- Implement hover states for all interactive elements
- Use gentle transitions for all state changes
- Maintain consistent border radius within component families
- Test color combinations for accessibility compliance

### **Don'ts**
- Never use harsh black (#000000) for text
- Avoid sharp corners on user-facing elements
- Don't use more than 3 different border radii in a single view
- Never skip hover states on interactive elements
- Avoid jarring animations or sudden layout shifts

### **Testing Checklist**
- [ ] Color contrast meets AA standards minimum
- [ ] Touch targets are at least 44px
- [ ] Hover states work on all interactive elements
- [ ] Animations feel gentle and natural
- [ ] Typography hierarchy is clear and readable
- [ ] Components work in both light conditions
- [ ] Focus states are visible and accessible