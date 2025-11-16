const mongoose = require('mongoose');
const User = require('../models/User');
const Product = require('../models/Product');
const Order = require('../models/Order');
require('dotenv').config();

const createTestOrders = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Get test user
    let user = await User.findOne({ email: 'test@example.com' });
    if (!user) {
      console.log('Creating test user...');
      user = new User({
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123'
      });
      await user.save();
    }

    // Get some products
    const products = await Product.find().limit(5);
    if (products.length === 0) {
      console.log('No products found. Please run: npm run setup');
      process.exit(1);
    }

    console.log(`Found ${products.length} products`);

    // Create 5 test orders with different statuses
    const statuses = ['pending', 'processing', 'shipped', 'delivered', 'delivered'];
    const orders = [];

    for (let i = 0; i < 5; i++) {
      // Select 2-3 random products for each order
      const numItems = Math.floor(Math.random() * 2) + 2;
      const orderItems = [];
      let totalAmount = 0;

      for (let j = 0; j < numItems; j++) {
        const product = products[Math.floor(Math.random() * products.length)];
        const quantity = Math.floor(Math.random() * 3) + 1;
        const price = product.price;

        orderItems.push({
          product: product._id,
          quantity,
          price
        });

        totalAmount += price * quantity;
      }

      const order = new Order({
        user: user._id,
        items: orderItems,
        total: totalAmount,
        status: statuses[i],
        shippingAddress: `${123 + i} Test Street, Test City, Test Country`,
        paymentMethod: i % 2 === 0 ? 'Credit Card' : 'Cash on Delivery',
        createdAt: new Date(Date.now() - (i * 24 * 60 * 60 * 1000)) // Spread over 5 days
      });

      await order.save();
      orders.push(order);
      console.log(`✓ Created order ${i + 1}: ${order.status} - $${totalAmount.toFixed(2)}`);
    }

    // Calculate total revenue
    const totalRevenue = orders
      .filter(o => o.status !== 'cancelled')
      .reduce((sum, o) => sum + o.total, 0);

    console.log('\n✅ Test orders created successfully!');
    console.log(`\nSummary:`);
    console.log(`- Total Orders: ${orders.length}`);
    console.log(`- Total Revenue: $${totalRevenue.toFixed(2)}`);
    console.log(`- User: ${user.email}`);
    console.log(`\nYou can now view these orders in the admin dashboard!`);

    process.exit(0);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
};

createTestOrders();
