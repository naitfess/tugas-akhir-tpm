const { Event, Location, User, Sequelize } = require('../models');
const { Op } = Sequelize;

exports.getAllEvents = async (req, res) => {
  try {
    const events = await Event.findAll({ include: [{ model: User, attributes: ['id', 'name'] }] });
    res.json(events);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getEventById = async (req, res) => {
  try {
    const event = await Event.findByPk(req.params.id, { include: [Location, { model: User, attributes: ['id', 'name'] }] });
    if (!event) return res.status(404).json({ message: 'Event not found' });
    res.json(event);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.searchEvents = async (req, res) => {
  const { name, category, longitude, latitude, radius } = req.query;
  let where = {};
  if (name) where.name = { [Op.like]: `%${name}%` };
  if (category) where.category = category;
  if (longitude && latitude && radius) {
    // Haversine formula for nearby events
    const R = 6371; // Earth radius in km
    const lon = parseFloat(longitude);
    const lat = parseFloat(latitude);
    where[Op.and] = Sequelize.literal(`ST_Distance_Sphere(point(longitude, latitude), point(${lon}, ${lat})) <= ${parseFloat(radius) * 1000}`);
  }
  try {
    const events = await Event.findAll({ where });
    res.json(events);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getNearbyEvents = async (req, res) => {
  const { longitude, latitude, radius } = req.query;
  if (!longitude || !latitude || !radius) return res.status(400).json({ message: 'Missing coordinates or radius' });
  try {
    const events = await Event.findAll({
      where: Sequelize.literal(`ST_Distance_Sphere(point(longitude, latitude), point(${parseFloat(longitude)}, ${parseFloat(latitude)})) <= ${parseFloat(radius) * 1000}`)
    });
    res.json(events);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Tambah: upload event image
exports.uploadEventImage = async (req, res) => {
  try {
    const eventId = req.params.id;
    if (!req.file) return res.status(400).json({ message: 'No file uploaded' });
    const imageUrl = `/uploads/${req.file.filename}`;
    const event = await Event.findByPk(eventId);
    if (!event) return res.status(404).json({ message: 'Event not found' });
    await event.update({ image_url: imageUrl });
    res.json({ image_url: imageUrl });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
