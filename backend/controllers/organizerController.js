const { OrganizerRequest, User, Event, Location } = require('../models');

exports.applyOrganizer = async (req, res) => {
  const { organizationName, organizationDesc } = req.body;
  try {
    if (req.user.role === 'organizer') {
      return res.status(400).json({ message: 'You are already an organizer' });
    }
    const existing = await OrganizerRequest.findOne({ where: { userId: req.user.id, status: 'pending' } });
    if (existing) return res.status(400).json({ message: 'Already applied, waiting for approval' });
    const request = await OrganizerRequest.create({ userId: req.user.id, organizationName, organizationDesc });
    res.status(201).json(request);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.createEvent = async (req, res) => {
  const { name, description, category, date, longitude, latitude, time_zone_label, currency, price } = req.body;
  let image_url = null;
  if (req.file) {
    image_url = `/uploads/${req.file.filename}`;
  }
  try {
    const event = await Event.create({
      name,
      description,
      category,
      date,
      longitude,
      latitude,
      organizerId: req.user.id,
      time_zone_label,
      currency,
      price,
      image_url
    });
    res.status(201).json(event);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.editEvent = async (req, res) => {
  const { id } = req.params;
  const { name, description, category, date, longitude, latitude, time_zone_label, currency, price } = req.body;
  let image_url = null;
  if (req.file) {
    image_url = `/uploads/${req.file.filename}`;
  }
  try {
    const event = await Event.findOne({ where: { id, organizerId: req.user.id } });
    if (!event) return res.status(404).json({ message: 'Event not found' });
    const updateData = { name, description, category, date, longitude, latitude, time_zone_label, currency, price };
    if (image_url) updateData.image_url = image_url;
    await event.update(updateData);
    res.json(event);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.deleteEvent = async (req, res) => {
  const { id } = req.params;
  try {
    const event = await Event.findOne({ where: { id, organizerId: req.user.id } });
    if (!event) return res.status(404).json({ message: 'Event not found' });
    await event.destroy();
    res.json({ message: 'Event deleted' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.addLocation = async (req, res) => {
  const { eventId, name, longitude, latitude, type } = req.body;
  try {
    const event = await Event.findOne({ where: { id: eventId, organizerId: req.user.id } });
    if (!event) return res.status(404).json({ message: 'Event not found' });
    const location = await Location.create({ eventId, name, longitude, latitude, type });
    res.status(201).json(location);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.editLocation = async (req, res) => {
  const { id } = req.params;
  const { name, longitude, latitude, type } = req.body;
  try {
    const location = await Location.findByPk(id);
    if (!location) return res.status(404).json({ message: 'Location not found' });
    const event = await Event.findOne({ where: { id: location.eventId, organizerId: req.user.id } });
    if (!event) return res.status(403).json({ message: 'Forbidden' });
    await location.update({ name, longitude, latitude, type });
    res.json(location);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.deleteLocation = async (req, res) => {
  const { id } = req.params;
  try {
    const location = await Location.findByPk(id);
    if (!location) return res.status(404).json({ message: 'Location not found' });
    const event = await Event.findOne({ where: { id: location.eventId, organizerId: req.user.id } });
    if (!event) return res.status(403).json({ message: 'Forbidden' });
    await location.destroy();
    res.json({ message: 'Location deleted' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getMyEvents = async (req, res) => {
  try {
    const events = await Event.findAll({ where: { organizerId: req.user.id } });
    res.json(events);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getMyEventLocations = async (req, res) => {
  try {
    const events = await Event.findAll({
      where: { organizerId: req.user.id },
      include: [Location]
    });
    // Gabungkan semua lokasi dari semua event
    const locations = events.reduce((acc, event) => {
      if (event.Locations) acc.push(...event.Locations);
      return acc;
    }, []);
    res.json(locations);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getMyEventLocationsByEvent = async (req, res) => {
  try {
    const eventId = req.params.eventId;
    const { Event, Location } = require('../models');
    const event = await Event.findOne({ where: { id: eventId, organizerId: req.user.id }, include: [Location] });
    if (!event) return res.status(404).json({ message: 'Event not found or not yours' });
    res.json(event.Locations);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
