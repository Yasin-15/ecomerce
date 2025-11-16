# 💳 Multiple Payment Methods

This e-commerce app supports multiple payment methods to provide flexibility for customers.

## Supported Payment Methods

### 1. 💳 Credit/Debit Card (Stripe)
- Secure card payment processing
- Supports all major card brands (Visa, Mastercard, Amex, etc.)
- Real-time validation
- PCI compliant

**Required Information:**
- Cardholder name
- Card number (16 digits)
- Expiry date (MM/YY)
- CVV (3 digits)

### 2. 🅿️ PayPal
- Pay with your PayPal account
- Fast and secure checkout
- Buyer protection included

**Required Information:**
- PayPal email address

### 3. 🍎 Apple Pay
- One-tap payment for iOS users
- Biometric authentication
- Secure tokenized payments

**Required Information:**
- Apple Pay token (handled automatically)

### 4. 🤖 Google Pay
- Quick checkout for Android users
- Secure and convenient
- Saved payment methods

**Required Information:**
- Google Pay token (handled automatically)

### 5. 🏦 Bank Transfer
- Direct bank account transfer
- Lower processing fees
- Suitable for large orders

**Required Information:**
- Bank name
- Account number

### 6. 💵 Cash on Delivery
- Pay when you receive your order
- No upfront payment required
- Small processing fee may apply

**Required Information:**
- Confirmation only

## Implementation Details

### Backend API

#### Get Available Payment Methods
```http
GET /api/payments/methods
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": "stripe",
    "name": "Credit/Debit Card",
    "description": "Pay securely with your card",
    "icon": "credit_card",
    "enabled": true,
    "processingFee": 0
  },
  ...
]
```

#### Process Payment
```http
POST /api/payments/process
Authorization: Bearer <token>
Content-Type: application/json

{
  "orderId": "order_id",
  "paymentMethod": "stripe",
  "paymentDetails": {
    "cardNumber": "4242424242424242",
    "expiry": "12/25",
    "cvv": "123",
    "name": "John Doe"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Payment processed successfully",
  "order": {
    "_id": "order_id",
    "paymentStatus": "paid",
    "paymentDetails": {
      "method": "stripe",
      "transactionId": "STRIPE-1234567890",
      "paidAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

### Frontend Implementation

The payment flow consists of two screens:

1. **CheckoutScreen** - Collect shipping address and apply coupons
2. **PaymentMethodScreen** - Select payment method and enter payment details

#### Navigation Flow
```
Cart → Checkout → Payment Method Selection → Order Success
```

#### Payment Method Screen Features
- Dynamic payment method loading from backend
- Method-specific forms (card details, PayPal email, etc.)
- Real-time validation
- Processing fee display
- Secure payment processing
- Error handling

## Security Considerations

### Current Implementation (Demo)
- Simulated payment processing for demonstration
- No real payment gateway integration
- Test card numbers accepted

### Production Recommendations

1. **Stripe Integration**
   ```javascript
   const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
   const paymentIntent = await stripe.paymentIntents.create({
     amount: amount * 100, // Convert to cents
     currency: 'usd',
     payment_method: paymentMethodId,
     confirm: true
   });
   ```

2. **PayPal Integration**
   ```javascript
   const paypal = require('@paypal/checkout-server-sdk');
   // Configure PayPal SDK and process payment
   ```

3. **Environment Variables**
   ```env
   STRIPE_SECRET_KEY=sk_test_...
   STRIPE_PUBLISHABLE_KEY=pk_test_...
   PAYPAL_CLIENT_ID=...
   PAYPAL_CLIENT_SECRET=...
   ```

4. **PCI Compliance**
   - Never store raw card numbers
   - Use tokenization
   - Implement SSL/TLS
   - Regular security audits

5. **Fraud Prevention**
   - Implement 3D Secure
   - Address verification
   - CVV verification
   - Velocity checks
   - IP geolocation

## Testing

Use the provided test file: `test_payments_api.http`

### Test Card Numbers (Stripe)
- Success: `4242424242424242`
- Decline: `4000000000000002`
- Insufficient funds: `4000000000009995`

### Test PayPal Account
- Email: `test@example.com`

## Adding New Payment Methods

To add a new payment method:

1. **Backend** - Add to `backend/routes/payments.js`:
   ```javascript
   case 'new_method':
     paymentResult = await processNewMethod(paymentDetails, order.total);
     break;
   ```

2. **Add to payment methods list**:
   ```javascript
   {
     id: 'new_method',
     name: 'New Payment Method',
     description: 'Description here',
     icon: 'icon_name',
     enabled: true,
     processingFee: 0
   }
   ```

3. **Frontend** - Add form in `lib/screens/payment_method_screen.dart`:
   ```dart
   case 'new_method':
     return _buildNewMethodForm();
   ```

4. **Update API Service** - Already handles dynamic methods

## Order Model Updates

The Order model now includes:
```javascript
paymentDetails: {
  method: String,        // Payment method used
  transactionId: String, // Transaction ID from gateway
  paidAt: Date          // Payment timestamp
}
```

## User Experience

### Payment Method Selection
- Visual cards with icons
- Clear descriptions
- Processing fee display
- Selected state indication

### Payment Forms
- Method-specific fields
- Input validation
- Helpful placeholders
- Error messages

### Processing States
- Loading indicators
- Success confirmation
- Error handling
- Retry options

## Future Enhancements

- [ ] Saved payment methods
- [ ] Recurring payments
- [ ] Split payments
- [ ] Gift cards
- [ ] Cryptocurrency payments
- [ ] Buy now, pay later (Klarna, Afterpay)
- [ ] Payment method recommendations
- [ ] Multi-currency support
- [ ] Refund processing
- [ ] Payment analytics

## Support

For payment-related issues:
1. Check order status in Orders screen
2. Verify payment details
3. Contact support with order ID
4. Check payment gateway status

## API Endpoints Summary

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/payments/methods` | GET | Get available payment methods |
| `/api/payments/process` | POST | Process a payment |

## Related Files

- Backend: `backend/routes/payments.js`
- Frontend: `lib/screens/payment_method_screen.dart`
- API Service: `lib/services/api_service.dart`
- Order Model: `backend/models/Order.js`
- Tests: `test_payments_api.http`
