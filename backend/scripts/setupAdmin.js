const mongoose = require('mongoose');
const User = require('../models/User');
const Product = require('../models/Product');
const Order = require('../models/Order');
const seedProducts = require('../utils/seedData');
require('dotenv').config();

const setupAdmin = async () => {
  try {
    console.log('🚀 Setting up Admin Dashboard...\n');
    
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✓ Connected to MongoDB');

    // 1. Create/Update Admin User
    console.log('\n📝 Creating admin user...');
    let admin = await User.findOne({ email: 'admin@example.com' });
    if (admin) {
      admin.isAdmin = true;
      await admin.save();
      console.log('✓ Updated existing user to admin');
    } else {
      admin = new User({
        name: 'Admin User',
        email: 'admin@example.com',
        password: 'admin123',
        isAdmin: true
      });
      await admin.save();
      console.log('✓ Created new admin user');
    }

    // 2. Create Test User
    console.log('\n📝 Creating test user...');
    let testUser = await User.findOne({ email: 'test@example.com' });
    if (!testUser) {
      testUser = new User({
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123'
      });
      await testUser.save();
      console.log('✓ Created test user');
    } else {
      console.log('✓ Test user already exists');
    }

    // 3. Seed Products
    console.log('\n📦 Seeding products...');
    const existingProducts = await Product.countDocuments();
    if (existingProducts === 0) {
      await Product.insertMany(seedProducts);
      console.log(`✓ Created ${seedProducts.length} products`);
    } else {
      console.log(`✓ ${existingProducts} products already exist`);
    }

    // 4. Create Test Orders
    console.log('\n🛍️  Creating test orders...');
    const existingOrders = await Order.countDocuments();
    if (existingOrders === 0) {
      const products = await Product.find().limit(5);
      const statuses = ['pending', 'processing', 'shipped', 'delivered', 'delivered'];
      
      for (let i = 0; i < 5; i++) {
        const numItems = Math.floor(Math.random() * 2) + 2;
        const orderItems = [];
        let totalAmount = 0;

        for (let j = 0; j < numItems; j++) {
          const product = products[Math.floor(Math.random() * products.length)];
          const quantity = Math.floor(Math.random() * 3) + 1;
          
          orderItems.push({
            product: product._id,
            quantity,
            price: product.price
          });
          
          totalAmount += product.price * quantity;
        }

        const order = new Order({
          user: testUser._id,
          items: orderItems,
          total: totalAmount,
          status: statuses[i],
          shippingAddress: `${123 + i} Test Street, Test City, Test Country`,
          paymentMethod: i % 2 === 0 ? 'Credit Card' : 'Cash on Delivery',
          createdAt: new Date(Date.now() - (i * 24 * 60 * 60 * 1000))
        });

        await order.save();
      }
      console.log('✓ Created 5 test orders');
    } else {
      console.log(`✓ ${existingOrders} orders already exist`);
    }

    // 5. Calculate Stats
    console.log('\n📊 Dashboard Statistics:');
    const totalProducts = await Product.countDocuments();
    const totalOrders = await Order.countDocuments();
    const totalUsers = await User.countDocuments();
    const revenueResult = await Order.aggregate([
      { $match: { status: { $ne: 'cancelled' } } },
      { $group: { _id: null, total: { $sum: '$total' } } }
    ]);
    const totalRevenue = revenueResult[0]?.total || 0;

    console.log(`   Products: ${totalProducts}`);
    console.log(`   Orders: ${totalOrders}`);
    console.log(`   Users: ${totalUsers}`);
    console.log(`   Revenue: $${totalRevenue.toFixed(2)}`);

    console.log('\n✅ Admin Dashboard Setup Complete!\n');
    console.log('🔐 Admin Credentials:');
    console.log('   Email: admin@example.com');
    console.log('   Password: admin123\n');
    console.log('👤 Test User Credentials:');
    console.log('   Email: test@example.com');
    console.log('   Password: password123\n');
    console.log('🚀 Next Steps:');
    console.log('   1. Start the server: npm run dev');
    console.log('   2. Run Flutter app: flutter run');
    console.log('   3. Login as admin');
    console.log('   4. Go to Profile → Admin Dashboard\n');

    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
};

setupAdmin();
