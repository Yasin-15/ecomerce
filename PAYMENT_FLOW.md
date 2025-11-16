# 💳 Payment Flow Diagram

## Complete User Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER JOURNEY                             │
└─────────────────────────────────────────────────────────────────┘

1. SHOPPING
   ┌──────────────┐
   │ Browse       │
   │ Products     │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │ Add to Cart  │
   └──────┬───────┘
          │
          ▼

2. CHECKOUT
   ┌──────────────────────┐
   │ CheckoutScreen       │
   │                      │
   │ • Shipping Address   │
   │ • Coupon Code        │
   │ • Order Summary      │
   └──────┬───────────────┘
          │
          │ [Place Order]
          ▼
   ┌──────────────────────┐
   │ Backend API          │
   │ POST /api/orders     │
   │                      │
   │ • Create Order       │
   │ • Clear Cart         │
   │ • Return Order ID    │
   └──────┬───────────────┘
          │
          ▼

3. PAYMENT SELECTION
   ┌──────────────────────────────────────┐
   │ PaymentMethodScreen                  │
   │                                      │
   │ GET /api/payments/methods            │
   │                                      │
   │ Available Methods:                   │
   │ ┌────────────────────────────────┐  │
   │ │ 💳 Credit/Debit Card (Stripe) │  │
   │ └────────────────────────────────┘  │
   │ ┌────────────────────────────────┐  │
   │ │ 🅿️  PayPal                     │  │
   │ └────────────────────────────────┘  │
   │ ┌────────────────────────────────┐  │
   │ │ 🍎 Apple Pay                   │  │
   │ └────────────────────────────────┘  │
   │ ┌────────────────────────────────┐  │
   │ │ 🤖 Google Pay                  │  │
   │ └────────────────────────────────┘  │
   │ ┌────────────────────────────────┐  │
   │ │ 🏦 Bank Transfer               │  │
   │ └────────────────────────────────┘  │
   │ ┌────────────────────────────────┐  │
   │ │ 💵 Cash on Delivery            │  │
   │ └────────────────────────────────┘  │
   └──────┬───────────────────────────────┘
          │
          │ [User Selects Method]
          ▼

4. PAYMENT DETAILS
   ┌──────────────────────────────────────┐
   │ Method-Specific Form                 │
   │                                      │
   │ IF Stripe:                           │
   │   • Card Number                      │
   │   • Expiry Date                      │
   │   • CVV                              │
   │   • Cardholder Name                  │
   │                                      │
   │ IF PayPal:                           │
   │   • PayPal Email                     │
   │                                      │
   │ IF Bank Transfer:                    │
   │   • Bank Name                        │
   │   • Account Number                   │
   │                                      │
   │ IF Cash on Delivery:                 │
   │   • Confirmation Only                │
   │                                      │
   │ IF Digital Wallet:                   │
   │   • Auto-generated Token             │
   └──────┬───────────────────────────────┘
          │
          │ [Complete Payment]
          ▼

5. PAYMENT PROCESSING
   ┌──────────────────────────────────────┐
   │ Backend API                          │
   │ POST /api/payments/process           │
   │                                      │
   │ Request:                             │
   │ {                                    │
   │   orderId: "...",                    │
   │   paymentMethod: "stripe",           │
   │   paymentDetails: {...}              │
   │ }                                    │
   └──────┬───────────────────────────────┘
          │
          ▼
   ┌──────────────────────────────────────┐
   │ Payment Gateway                      │
   │                                      │
   │ • Validate Details                   │
   │ • Process Payment                    │
   │ • Generate Transaction ID            │
   └──────┬───────────────────────────────┘
          │
          ├─── SUCCESS ───┐
          │               │
          ▼               ▼
   ┌──────────────┐  ┌──────────────┐
   │ Update Order │  │ Update Order │
   │              │  │              │
   │ • Status:    │  │ • Status:    │
   │   processing │  │   pending    │
   │ • Payment:   │  │ • Payment:   │
   │   paid       │  │   failed     │
   │ • Save       │  │              │
   │   Transaction│  │              │
   └──────┬───────┘  └──────┬───────┘
          │                 │
          ▼                 ▼
   ┌──────────────┐  ┌──────────────┐
   │ Success      │  │ Error        │
   │ Response     │  │ Response     │
   └──────┬───────┘  └──────┬───────┘
          │                 │
          ▼                 ▼

6. COMPLETION
   ┌──────────────────────┐
   │ OrderSuccessScreen   │
   │                      │
   │ ✅ Order Confirmed   │
   │ 📦 Order ID: #12345  │
   │ 💳 Payment: Paid     │
   │                      │
   │ [Track Order]        │
   │ [Continue Shopping]  │
   └──────────────────────┘
```

## Backend Payment Processing Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND PROCESSING                            │
└─────────────────────────────────────────────────────────────────┘

POST /api/payments/process
          │
          ▼
┌─────────────────────┐
│ Validate Request    │
│ • Order ID          │
│ • Payment Method    │
│ • Payment Details   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Find Order          │
│ • Check exists      │
│ • Verify ownership  │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ Route to Payment Processor              │
│                                         │
│ switch (paymentMethod) {                │
│   case 'stripe':                        │
│     → processStripePayment()            │
│   case 'paypal':                        │
│     → processPayPalPayment()            │
│   case 'bank_transfer':                 │
│     → processBankTransfer()             │
│   case 'cash_on_delivery':              │
│     → Auto-approve                      │
│   case 'apple_pay':                     │
│   case 'google_pay':                    │
│     → processDigitalWallet()            │
│ }                                       │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────┐
│ Payment Gateway     │
│ • Validate          │
│ • Authorize         │
│ • Capture           │
│ • Return Result     │
└─────────┬───────────┘
          │
          ├─── SUCCESS ───┬─── FAILURE ───┐
          │               │               │
          ▼               ▼               ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────┐
│ Update Order    │ │ Update Order│ │ Return Error│
│                 │ │             │ │             │
│ paymentStatus:  │ │ paymentStatus│ │ status: 400│
│   'paid'        │ │   'failed'  │ │ message:   │
│                 │ │             │ │   error    │
│ paymentDetails: │ │             │ │            │
│ {               │ │             │ │            │
│   method,       │ │             │ │            │
│   transactionId,│ │             │ │            │
│   paidAt        │ │             │ │            │
│ }               │ │             │ │            │
│                 │ │             │ │            │
│ status:         │ │             │ │            │
│   'processing'  │ │             │ │            │
│                 │ │             │ │            │
│ statusHistory:  │ │             │ │            │
│   + new entry   │ │             │ │            │
└─────────┬───────┘ └─────────┬───┘ └─────────┬───┘
          │                   │               │
          ▼                   ▼               ▼
┌─────────────────────────────────────────────────┐
│ Return Response                                 │
│                                                 │
│ SUCCESS:                                        │
│ {                                               │
│   success: true,                                │
│   message: "Payment processed successfully",    │
│   order: {...}                                  │
│ }                                               │
│                                                 │
│ FAILURE:                                        │
│ {                                               │
│   success: false,                               │
│   message: "Payment failed"                     │
│ }                                               │
└─────────────────────────────────────────────────┘
```

## Payment Method Specific Flows

### 💳 Stripe (Credit/Debit Card)

```
User Input → Validate Card → Stripe API → Token → Charge → Success/Fail
```

**Required:**
- Card Number (16 digits)
- Expiry (MM/YY)
- CVV (3 digits)
- Name

**Process:**
1. Validate card format
2. Create payment token
3. Charge card
4. Return transaction ID

### 🅿️ PayPal

```
User Input → Validate Email → PayPal API → Authorize → Capture → Success/Fail
```

**Required:**
- PayPal Email

**Process:**
1. Validate email format
2. Redirect to PayPal (in production)
3. User authorizes payment
4. Capture payment
5. Return transaction ID

### 🍎 Apple Pay / 🤖 Google Pay

```
User Tap → Biometric Auth → Wallet Token → Gateway → Success/Fail
```

**Required:**
- Wallet token (auto-generated)

**Process:**
1. User authenticates with biometric
2. Wallet generates payment token
3. Process tokenized payment
4. Return transaction ID

### 🏦 Bank Transfer

```
User Input → Validate Account → Bank API → Transfer → Confirm → Success/Fail
```

**Required:**
- Bank Name
- Account Number

**Process:**
1. Validate account details
2. Initiate transfer
3. Wait for confirmation
4. Return transaction ID

### 💵 Cash on Delivery

```
User Confirm → Create Order → Mark Pending → Deliver → Collect Cash
```

**Required:**
- Confirmation only

**Process:**
1. Confirm COD selection
2. Mark payment as pending
3. Process order for delivery
4. Collect cash on delivery

## Database Schema Updates

### Order Model

```javascript
{
  _id: ObjectId,
  user: ObjectId,
  items: [...],
  subtotal: Number,
  discount: Number,
  shippingFee: Number,
  total: Number,
  status: String,
  
  // NEW FIELDS
  paymentMethod: String,
  paymentStatus: String, // 'pending', 'paid', 'failed'
  paymentDetails: {
    method: String,        // 'stripe', 'paypal', etc.
    transactionId: String, // Gateway transaction ID
    paidAt: Date          // Payment timestamp
  },
  
  statusHistory: [...],
  shippingAddress: String,
  createdAt: Date
}
```

## Error Handling

```
┌─────────────────────────────────────┐
│ Error Scenarios                     │
├─────────────────────────────────────┤
│                                     │
│ 1. Invalid Payment Details          │
│    → Show validation error          │
│    → Allow retry                    │
│                                     │
│ 2. Payment Gateway Timeout          │
│    → Show timeout message           │
│    → Retry automatically            │
│                                     │
│ 3. Insufficient Funds               │
│    → Show specific error            │
│    → Suggest alternative method     │
│                                     │
│ 4. Card Declined                    │
│    → Show decline reason            │
│    → Allow different card           │
│                                     │
│ 5. Network Error                    │
│    → Show connection error          │
│    → Retry button                   │
│                                     │
│ 6. Order Not Found                  │
│    → Redirect to orders             │
│    → Show error message             │
│                                     │
└─────────────────────────────────────┘
```

## Security Measures

```
┌─────────────────────────────────────┐
│ Security Layers                     │
├─────────────────────────────────────┤
│                                     │
│ 1. HTTPS/TLS Encryption             │
│    ✓ All data encrypted in transit  │
│                                     │
│ 2. JWT Authentication               │
│    ✓ Verify user identity           │
│                                     │
│ 3. Order Ownership Check            │
│    ✓ User can only pay own orders   │
│                                     │
│ 4. Payment Tokenization             │
│    ✓ Never store raw card data      │
│                                     │
│ 5. Input Validation                 │
│    ✓ Sanitize all inputs            │
│                                     │
│ 6. Rate Limiting                    │
│    ✓ Prevent brute force            │
│                                     │
│ 7. Fraud Detection                  │
│    ✓ Monitor suspicious activity    │
│                                     │
└─────────────────────────────────────┘
```

## Testing Checklist

- [ ] Test each payment method
- [ ] Test with valid details
- [ ] Test with invalid details
- [ ] Test network errors
- [ ] Test timeout scenarios
- [ ] Test concurrent payments
- [ ] Test order updates
- [ ] Test payment status
- [ ] Test transaction IDs
- [ ] Test error messages
- [ ] Test UI loading states
- [ ] Test navigation flow
