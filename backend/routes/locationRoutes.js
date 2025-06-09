const express = require('express');
const router = express.Router();
const locationController = require('../controllers/locationController');

router.get('/event/:eventId', locationController.getLocationsByEvent);

module.exports = router;
