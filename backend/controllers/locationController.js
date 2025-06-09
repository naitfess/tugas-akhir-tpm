const { Location, Event } = require('../models');

exports.getLocationsByEvent = async (req, res) => {
  try {
    const locations = await Location.findAll({ where: { eventId: req.params.eventId } });
    res.json(locations);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
