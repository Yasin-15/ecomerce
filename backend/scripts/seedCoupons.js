const mongoose = require('mongoose');
require('dotenv').config();
const Coupon = require('../models/Coupon');

const coupons = [
  {
    code: 'WELCOME10',
    discountType: 'percentage',
    discountValue: 10,
    minOrderAmount: 50,
    maxDiscount: 20,
    expiryDate: new Date('2025-12-31'),
    usageLimit: 100,
    isActive: true
  },
  {
    code: 'SAVE20',
    discountType: 'fixed',
    discountValue: 20,
    minOrderAmount: 100,
    expiryDate: new Date('2025-12-31'),
    usageLimit: 50,
    isActive: true
  },
  {
    code: 'FREESHIP',
    discountType: 'fixed',
    discountValue: 5,
    minOrderAmount: 30,
    expiryDate: new Date('2025-12-31'),
    usageLimit: null,
    isActive: true
  },
  {
    code: 'MEGA50',
    discountType: 'percentage',
    discountValue: 50,
    minOrderAmount: 200,
    maxDiscount: 100,
    expiryDate: new Date('2025-06-30'),
    usageLimit: 20,
    isActive: true
  }
];

async function seedCoupons() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    await Coupon.deleteMany({});
    console.log('Cleared existing coupons');

    await Coupon.insertMany(coupons);
    console.log('Seeded coupons successfully');

    console.log('\nAvailable Coupons:');
    coupons.forEach(coupon => {
      console.log(`- ${coupon.code}: ${coupon.discountType === 'percentage' ? coupon.discountValue + '%' : '$' + coupon.discountValue} off`);
    });

    process.exit(0);
  } catch (error) {
    console.error('Error seeding coupons:', error);
    process.exit(1);
  }
}

seedCoupons();
