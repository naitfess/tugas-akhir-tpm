module.exports = (sequelize, DataTypes) => {
  const OrganizerRequest = sequelize.define('OrganizerRequest', {
    id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
    userId: { type: DataTypes.INTEGER, allowNull: false },
    status: { type: DataTypes.ENUM('pending', 'approved', 'rejected'), defaultValue: 'pending' },
    organizationName: { type: DataTypes.STRING, allowNull: false },
    organizationDesc: { type: DataTypes.TEXT, allowNull: false },
    // Tambahkan field lain sesuai kebutuhan form apply organizer
  });
  return OrganizerRequest;
};
