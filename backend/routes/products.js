const express = require('express');
const router = express.Router();
const Product = require('../models/Product');

// Get all products
router.get('/', async (req, res) => {
  try {
    const { category, search } = req.query;
    let query = {};
    
    if (category) query.category = category;
    if (search) query.name = { $regex: search, $options: 'i' };

    const products = await Product.find(query);
    res.json(products);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get product by ID
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json(product);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Seed products (for testing)
router.post('/seed', async (req, res) => {
  try {
    await Product.deleteMany({});
    const seedProducts = require('../utils/seedData');
    await Product.insertMany(seedProducts);
    res.json({ message: 'Products seeded successfully', count: seedProducts.length });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
