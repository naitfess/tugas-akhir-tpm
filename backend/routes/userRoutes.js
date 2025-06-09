const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middleware/authMiddleware');

router.get('/favorites', auth, userController.getFavorites);
router.post('/favorites', auth, userController.addFavorite);
router.delete('/favorites', auth, userController.removeFavorite);

module.exports = router;
