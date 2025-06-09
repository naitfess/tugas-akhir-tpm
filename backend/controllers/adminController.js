const { OrganizerRequest, User } = require('../models');

exports.getOrganizerRequests = async (req, res) => {
  try {
    const requests = await OrganizerRequest.findAll({
      where: { status: 'pending' },
      include: [{ model: User, attributes: ['id', 'name', 'username'] }],
    });
    res.json(requests);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.approveOrganizer = async (req, res) => {
  const { id } = req.params;
  try {
    const request = await OrganizerRequest.findByPk(id);
    if (!request) return res.status(404).json({ message: 'Request not found' });
    await request.update({ status: 'approved' });
    await User.update({ role: 'organizer' }, { where: { id: request.userId } });
    res.json({ message: 'Organizer approved' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.rejectOrganizer = async (req, res) => {
  const { id } = req.params;
  try {
    const request = await OrganizerRequest.findByPk(id);
    if (!request) return res.status(404).json({ message: 'Request not found' });
    await request.update({ status: 'rejected' });
    res.json({ message: 'Organizer rejected' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
