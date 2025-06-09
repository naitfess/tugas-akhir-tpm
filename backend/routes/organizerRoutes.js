const express = require('express');
const router = express.Router();
const organizerController = require('../controllers/organizerController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');

router.post('/apply', auth, organizerController.applyOrganizer);

// Event CRUD
router.post('/event', auth, role('organizer'), organizerController.createEvent);
router.put('/event/:id', auth, role('organizer'), organizerController.editEvent);
router.delete('/event/:id', auth, role('organizer'), organizerController.deleteEvent);

// Location CRUD
router.post('/location', auth, role('organizer'), organizerController.addLocation);
router.put('/location/:id', auth, role('organizer'), organizerController.editLocation);
router.delete('/location/:id', auth, role('organizer'), organizerController.deleteLocation);

// Get all events by the logged-in organizer
router.get('/my-events', auth, role('organizer'), organizerController.getMyEvents);
router.get('/my-locations', auth, role('organizer'), organizerController.getMyEventLocations);
router.get('/my-locations/:eventId', auth, role('organizer'), organizerController.getMyEventLocationsByEvent);

module.exports = router;
