const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const auth = require('../middleware/authMiddleware');

router.get('/', eventController.getAllEvents);
router.get('/:id', eventController.getEventById);
router.get('/search', eventController.searchEvents);
router.get('/nearby', eventController.getNearbyEvents);

module.exports = router;
