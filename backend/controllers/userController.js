const { User, Favorite, Event } = require('../models');

exports.getFavorites = async (req, res) => {
  try {
    const favorites = await Favorite.findAll({
      where: { userId: req.user.id },
      include: [{ model: Event }],
    });
    res.json(favorites);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.addFavorite = async (req, res) => {
  const { eventId } = req.body;
  try {
    const exists = await Favorite.findOne({ where: { userId: req.user.id, eventId } });
    if (exists) return res.status(400).json({ message: 'Already favorited' });
    const fav = await Favorite.create({ userId: req.user.id, eventId });
    res.status(201).json(fav);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.removeFavorite = async (req, res) => {
  const { eventId } = req.body;
  try {
    await Favorite.destroy({ where: { userId: req.user.id, eventId } });
    res.json({ message: 'Removed from favorites' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Tambah: update profile image
exports.updateProfileImage = async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ message: 'No file uploaded' });
    const imageUrl = `/uploads/${req.file.filename}`;
    await User.update({ image_url: imageUrl }, { where: { id: req.user.id } });
    res.json({ image_url: imageUrl });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
