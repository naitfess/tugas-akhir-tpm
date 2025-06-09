const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const auth = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');

router.get('/', eventController.getAllEvents);
router.get('/:id', eventController.getEventById);
router.get('/search', eventController.searchEvents);
router.get('/nearby', eventController.getNearbyEvents);
// Upload event image
router.post('/:id/image', auth, upload.single('image'), eventController.uploadEventImage);

module.exports = router;
