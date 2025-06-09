const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');

router.get('/favorites', auth, userController.getFavorites);
router.post('/favorites', auth, userController.addFavorite);
router.delete('/favorites', auth, userController.removeFavorite);
// Upload profile image
router.post('/profile/image', auth, upload.single('image'), userController.updateProfileImage);

module.exports = router;
