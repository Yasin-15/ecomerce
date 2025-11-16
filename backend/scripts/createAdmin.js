const mongoose = require('mongoose');
const User = require('../models/User');
require('dotenv').config();

const createAdmin = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    const email = process.argv[2] || 'admin@example.com';
    const password = process.argv[3] || 'admin123';
    const name = process.argv[4] || 'Admin User';

    // Check if user exists
    let user = await User.findOne({ email });
    
    if (user) {
      // Update existing user to admin
      user.isAdmin = true;
      await user.save();
      console.log(`✓ User ${email} updated to admin`);
    } else {
      // Create new admin user
      user = new User({
        name,
        email,
        password,
        isAdmin: true
      });
      await user.save();
      console.log(`✓ Admin user created: ${email}`);
    }

    console.log('\nAdmin credentials:');
    console.log(`Email: ${email}`);
    console.log(`Password: ${password}`);
    
    process.exit(0);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
};

createAdmin();
