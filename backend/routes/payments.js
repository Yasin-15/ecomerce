const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const Order = require('../models/Order');

// Process payment
router.post('/process', auth, async (req, res) => {
  try {
    const { orderId, paymentMethod, paymentDetails } = req.body;

    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    if (order.user.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    // Simulate payment processing based on method
    let paymentResult;
    switch (paymentMethod) {
      case 'stripe':
        paymentResult = await processStripePayment(paymentDetails, order.total);
        break;
      case 'paypal':
        paymentResult = await processPayPalPayment(paymentDetails, order.total);
        break;
      case 'bank_transfer':
        paymentResult = await processBankTransfer(paymentDetails, order.total);
        break;
      case 'cash_on_delivery':
        paymentResult = { success: true, transactionId: `COD-${Date.now()}` };
        break;
      case 'apple_pay':
      case 'google_pay':
        paymentResult = await processDigitalWallet(paymentMethod, paymentDetails, order.total);
        break;
      default:
        return res.status(400).json({ message: 'Invalid payment method' });
    }

    if (paymentResult.success) {
      order.paymentStatus = paymentMethod === 'cash_on_delivery' ? 'pending' : 'paid';
      order.paymentDetails = {
        method: paymentMethod,
        transactionId: paymentResult.transactionId,
        paidAt: new Date()
      };
      order.status = 'processing';
      order.statusHistory.push({
        status: 'processing',
        timestamp: new Date(),
        note: `Payment ${paymentMethod === 'cash_on_delivery' ? 'method confirmed' : 'received'}`
      });
      await order.save();

      res.json({
        success: true,
        message: 'Payment processed successfully',
        order
      });
    } else {
      order.paymentStatus = 'failed';
      await order.save();
      res.status(400).json({
        success: false,
        message: paymentResult.error || 'Payment failed'
      });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get payment methods
router.get('/methods', auth, async (req, res) => {
  try {
    const paymentMethods = [
      {
        id: 'stripe',
        name: 'Credit/Debit Card',
        description: 'Pay securely with your card',
        icon: 'credit_card',
        enabled: true,
        processingFee: 0
      },
      {
        id: 'paypal',
        name: 'PayPal',
        description: 'Pay with your PayPal account',
        icon: 'paypal',
        enabled: true,
        processingFee: 0
      },
      {
        id: 'apple_pay',
        name: 'Apple Pay',
        description: 'Pay with Apple Pay',
        icon: 'apple',
        enabled: true,
        processingFee: 0
      },
      {
        id: 'google_pay',
        name: 'Google Pay',
        description: 'Pay with Google Pay',
        icon: 'google',
        enabled: true,
        processingFee: 0
      },
      {
        id: 'bank_transfer',
        name: 'Bank Transfer',
        description: 'Direct bank transfer',
        icon: 'account_balance',
        enabled: true,
        processingFee: 0
      },
      {
        id: 'cash_on_delivery',
        name: 'Cash on Delivery',
        description: 'Pay when you receive',
        icon: 'local_shipping',
        enabled: true,
        processingFee: 2.00
      }
    ];

    res.json(paymentMethods);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Simulate Stripe payment processing
async function processStripePayment(paymentDetails, amount) {
  // In production, integrate with Stripe API
  // const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
  // const paymentIntent = await stripe.paymentIntents.create({...});
  
  return new Promise((resolve) => {
    setTimeout(() => {
      if (paymentDetails.cardNumber && paymentDetails.cardNumber.length >= 16) {
        resolve({
          success: true,
          transactionId: `STRIPE-${Date.now()}`
        });
      } else {
        resolve({
          success: false,
          error: 'Invalid card details'
        });
      }
    }, 1000);
  });
}

// Simulate PayPal payment processing
async function processPayPalPayment(paymentDetails, amount) {
  // In production, integrate with PayPal API
  return new Promise((resolve) => {
    setTimeout(() => {
      if (paymentDetails.email) {
        resolve({
          success: true,
          transactionId: `PAYPAL-${Date.now()}`
        });
      } else {
        resolve({
          success: false,
          error: 'Invalid PayPal details'
        });
      }
    }, 1000);
  });
}

// Simulate Bank Transfer processing
async function processBankTransfer(paymentDetails, amount) {
  return new Promise((resolve) => {
    setTimeout(() => {
      if (paymentDetails.accountNumber) {
        resolve({
          success: true,
          transactionId: `BANK-${Date.now()}`
        });
      } else {
        resolve({
          success: false,
          error: 'Invalid bank details'
        });
      }
    }, 1000);
  });
}

// Simulate Digital Wallet processing
async function processDigitalWallet(method, paymentDetails, amount) {
  return new Promise((resolve) => {
    setTimeout(() => {
      if (paymentDetails.token) {
        resolve({
          success: true,
          transactionId: `${method.toUpperCase()}-${Date.now()}`
        });
      } else {
        resolve({
          success: false,
          error: 'Invalid wallet token'
        });
      }
    }, 1000);
  });
}

module.exports = router;
