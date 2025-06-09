const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');

router.get('/organizer-requests', auth, role('admin'), adminController.getOrganizerRequests);
router.post('/organizer-requests/:id/approve', auth, role('admin'), adminController.approveOrganizer);
router.post('/organizer-requests/:id/reject', auth, role('admin'), adminController.rejectOrganizer);

module.exports = router;
