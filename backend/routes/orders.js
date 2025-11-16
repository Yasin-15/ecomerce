const express = require('express');
const router = express.Router();
const Order = require('../models/Order');
const Cart = require('../models/Cart');
const auth = require('../middleware/auth');

// Get user orders
router.get('/', auth, async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user._id })
      .populate('items.product')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Create order
router.post('/', auth, async (req, res) => {
  try {
    const { shippingAddress, paymentMethod, couponCode, discount } = req.body;

    const cart = await Cart.findOne({ user: req.user._id }).populate('items.product');

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }

    const subtotal = cart.items.reduce((sum, item) => sum + (item.product.price * item.quantity), 0);
    const shippingFee = 5;
    const finalDiscount = discount || 0;
    const total = subtotal + shippingFee - finalDiscount;

    const order = new Order({
      user: req.user._id,
      items: cart.items.map(item => ({
        product: item.product._id,
        quantity: item.quantity,
        price: item.product.price
      })),
      subtotal,
      discount: finalDiscount,
      couponCode: couponCode || null,
      shippingFee,
      total,
      shippingAddress,
      paymentMethod,
      statusHistory: [{
        status: 'pending',
        timestamp: new Date(),
        note: 'Order placed'
      }]
    });

    await order.save();

    // Clear cart
    cart.items = [];
    cart.total = 0;
    await cart.save();

    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get order by ID
router.get('/:id', auth, async (req, res) => {
  try {
    const order = await Order.findById(req.params.id).populate('items.product');
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Track order
router.get('/:id/track', auth, async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    res.json({
      orderId: order._id,
      status: order.status,
      trackingNumber: order.trackingNumber,
      statusHistory: order.statusHistory,
      estimatedDelivery: order.estimatedDelivery
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
