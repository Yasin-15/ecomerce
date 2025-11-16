# ✅ Payment Methods Testing Checklist

## Pre-Testing Setup

- [ ] Backend server is running (`cd backend && npm start`)
- [ ] Flutter app is running (`flutter run`)
- [ ] User is logged in
- [ ] Products exist in database
- [ ] Cart has items

## 1. Credit/Debit Card (Stripe) Testing

### Valid Card
- [ ] Navigate to checkout
- [ ] Enter shipping address
- [ ] Click "Place Order"
- [ ] Select "Credit/Debit Card"
- [ ] Enter valid card details:
  - Card Number: `4242424242424242`
  - Expiry: `12/25`
  - CVV: `123`
  - Name: `John Doe`
- [ ] Click "Complete Payment"
- [ ] Verify loading indicator appears
- [ ] Verify redirect to success screen
- [ ] Verify order appears in Orders screen
- [ ] Verify payment status is "paid"

### Invalid Card
- [ ] Repeat flow with invalid card number: `1234567890123456`
- [ ] Verify error message appears
- [ ] Verify form remains visible
- [ ] Verify can retry with valid card

### Empty Fields
- [ ] Try to submit with empty fields
- [ ] Verify validation messages
- [ ] Fill all fields and submit successfully

## 2. PayPal Testing

### Valid Email
- [ ] Navigate to checkout
- [ ] Enter shipping address
- [ ] Click "Place Order"
- [ ] Select "PayPal"
- [ ] Enter email: `test@example.com`
- [ ] Click "Complete Payment"
- [ ] Verify payment processes successfully
- [ ] Verify order created with PayPal method

### Invalid Email
- [ ] Try with invalid email format
- [ ] Verify error handling
- [ ] Retry with valid email

## 3. Apple Pay Testing

- [ ] Navigate to checkout
- [ ] Enter shipping address
- [ ] Click "Place Order"
- [ ] Select "Apple Pay"
- [ ] Verify info message displays
- [ ] Click "Complete Payment"
- [ ] Verify payment processes (simulated)
- [ ] Verify order created

## 4. Google Pay Testing

- [ ] Navigate to checkout
- [ ] Enter shipping address
- [ ] Click "Place Order"
- [ ] Select "Google Pay"
- [ ] Verify info message displays
- [ ] Click "Complete Payment"
- [ ] Verify payment processes (simulated)
- [ ] Verify order created

## 5. Bank Transfer Testing

### Valid Details
- [ ] Navigate to checkout
- [ ] Enter shipping address
- [ ] Click "Place Order"
- [ ] Select "Bank Transfer"
- [ ] Enter bank name: `Example Bank`
- [ ] Enter account number: `1234567890`
- [ ] Click "Complete Payment"
- [ ] Verify payment processes
- [ ] Verify order created

### Empty Fields
- [ ] Try with empty fields
- [ ] Verify validation
- [ ] Fill and submit successfully

## 6. Cash on Delivery Testing

- [ ] Navigate to checkout
- [ ] Enter shipping address
- [ ] Click "Place Order"
- [ ] Select "Cash on Delivery"
- [ ] Verify info message about COD
- [ ] Verify processing fee displayed ($2.00)
- [ ] Click "Complete Payment"
- [ ] Verify order created
- [ ] Verify payment status is "pending"

## Backend API Testing

### Get Payment Methods
- [ ] Open `test_payments_api.http`
- [ ] Update token
- [ ] Send GET request to `/api/payments/methods`
- [ ] Verify 6 payment methods returned
- [ ] Verify each method has required fields:
  - id
  - name
  - description
  - icon
  - enabled
  - processingFee

### Process Stripe Payment
- [ ] Create an order first
- [ ] Copy order ID
- [ ] Update `test_payments_api.http` with order ID and token
- [ ] Send POST request to `/api/payments/process` with Stripe details
- [ ] Verify success response
- [ ] Verify order updated in database
- [ ] Verify transaction ID generated

### Process PayPal Payment
- [ ] Create new order
- [ ] Send POST request with PayPal details
- [ ] Verify success response
- [ ] Verify order updated

### Process Bank Transfer
- [ ] Create new order
- [ ] Send POST request with bank details
- [ ] Verify success response
- [ ] Verify order updated

### Process COD
- [ ] Create new order
- [ ] Send POST request with COD confirmation
- [ ] Verify success response
- [ ] Verify payment status is "pending"

### Process Digital Wallet
- [ ] Create new order
- [ ] Send POST request with wallet token
- [ ] Verify success response
- [ ] Verify order updated

## UI/UX Testing

### Payment Method Cards
- [ ] Verify all 6 methods display
- [ ] Verify icons show correctly
- [ ] Verify descriptions are clear
- [ ] Verify processing fees display (COD)
- [ ] Verify tap to select works
- [ ] Verify selected state shows (border + checkmark)

### Forms
- [ ] Verify correct form shows for each method
- [ ] Verify input fields have proper labels
- [ ] Verify placeholders are helpful
- [ ] Verify keyboard types are correct (number, email, text)
- [ ] Verify max length enforced (card number, CVV)

### Loading States
- [ ] Verify loading indicator during payment processing
- [ ] Verify button disabled during processing
- [ ] Verify button text changes to loading indicator

### Error Handling
- [ ] Verify error messages display clearly
- [ ] Verify error messages are user-friendly
- [ ] Verify can dismiss error and retry
- [ ] Verify form data persists after error

### Navigation
- [ ] Verify back button works
- [ ] Verify can return to checkout
- [ ] Verify success redirects to order success
- [ ] Verify order success has correct details

## Order Verification

### Order Details
- [ ] Open Orders screen
- [ ] Find the test order
- [ ] Verify order ID matches
- [ ] Verify payment method is correct
- [ ] Verify payment status is correct
- [ ] Verify total amount is correct

### Database Check
- [ ] Check order in MongoDB
- [ ] Verify `paymentMethod` field
- [ ] Verify `paymentStatus` field
- [ ] Verify `paymentDetails` object:
  - method
  - transactionId
  - paidAt (if paid)

## Edge Cases

### Network Errors
- [ ] Disable network
- [ ] Try to process payment
- [ ] Verify error message
- [ ] Re-enable network
- [ ] Verify can retry

### Invalid Order ID
- [ ] Manually call API with invalid order ID
- [ ] Verify 404 error returned
- [ ] Verify error message is clear

### Unauthorized Access
- [ ] Try to pay for another user's order
- [ ] Verify 403 error returned
- [ ] Verify security check works

### Expired Token
- [ ] Use expired JWT token
- [ ] Try to process payment
- [ ] Verify 401 error returned
- [ ] Verify redirects to login

## Integration Testing

### With Cart
- [ ] Add items to cart
- [ ] Verify cart total
- [ ] Complete checkout
- [ ] Verify cart cleared after payment

### With Coupons
- [ ] Apply coupon at checkout
- [ ] Verify discount applied
- [ ] Complete payment
- [ ] Verify order total includes discount
- [ ] Verify coupon usage incremented

### With Order Tracking
- [ ] Complete payment
- [ ] Go to Orders screen
- [ ] Click "Track Order"
- [ ] Verify payment status shows
- [ ] Verify payment method shows

## Performance Testing

### Load Time
- [ ] Measure time to load payment methods
- [ ] Should be < 1 second
- [ ] Verify no lag in UI

### Payment Processing
- [ ] Measure time to process payment
- [ ] Should be < 3 seconds (simulated)
- [ ] Verify smooth animation

### Multiple Payments
- [ ] Process 5 payments in sequence
- [ ] Verify all succeed
- [ ] Verify no memory leaks
- [ ] Verify no performance degradation

## Security Testing

### Authentication
- [ ] Try to access without login
- [ ] Verify redirects to login
- [ ] Login and verify access granted

### Authorization
- [ ] Try to pay for another user's order
- [ ] Verify access denied
- [ ] Verify error message

### Input Validation
- [ ] Try SQL injection in card number
- [ ] Try XSS in name field
- [ ] Verify inputs sanitized
- [ ] Verify no security issues

## Accessibility Testing

### Screen Reader
- [ ] Enable screen reader
- [ ] Navigate through payment methods
- [ ] Verify all elements announced
- [ ] Verify form labels read correctly

### Keyboard Navigation
- [ ] Use tab to navigate
- [ ] Verify can select payment method
- [ ] Verify can fill form
- [ ] Verify can submit

### Color Contrast
- [ ] Verify text is readable
- [ ] Verify selected state is clear
- [ ] Verify error messages stand out

## Cross-Platform Testing

### iOS
- [ ] Test on iOS simulator/device
- [ ] Verify all methods work
- [ ] Verify UI looks correct
- [ ] Verify Apple Pay shows

### Android
- [ ] Test on Android emulator/device
- [ ] Verify all methods work
- [ ] Verify UI looks correct
- [ ] Verify Google Pay shows

### Web (if applicable)
- [ ] Test in Chrome
- [ ] Test in Safari
- [ ] Test in Firefox
- [ ] Verify responsive design

## Documentation Testing

### Code Comments
- [ ] Review backend code comments
- [ ] Review frontend code comments
- [ ] Verify comments are helpful

### API Documentation
- [ ] Review PAYMENT_METHODS.md
- [ ] Verify examples work
- [ ] Verify instructions clear

### Setup Guide
- [ ] Follow PAYMENT_SETUP.md
- [ ] Verify steps work
- [ ] Verify no missing information

## Final Checks

### Code Quality
- [ ] No console errors
- [ ] No warnings
- [ ] No deprecated APIs used
- [ ] Code follows style guide

### User Experience
- [ ] Flow is intuitive
- [ ] Messages are clear
- [ ] Loading states are smooth
- [ ] Success feedback is satisfying

### Production Readiness
- [ ] Environment variables documented
- [ ] Error logging implemented
- [ ] Security measures in place
- [ ] Ready for real gateway integration

## Test Results Summary

### Passed: _____ / _____
### Failed: _____ / _____
### Blocked: _____ / _____

## Issues Found

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

## Notes

_______________________________________________
_______________________________________________
_______________________________________________

## Sign-off

- [ ] All critical tests passed
- [ ] All issues documented
- [ ] Ready for production (with real gateways)

**Tested by:** _______________
**Date:** _______________
**Version:** 1.0.0
