module.exports = (sequelize, DataTypes) => {
  const Location = sequelize.define('Location', {
    id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
    eventId: { type: DataTypes.INTEGER, allowNull: false },
    name: { type: DataTypes.STRING, allowNull: false },
    longitude: { type: DataTypes.STRING, allowNull: false },
    latitude: { type: DataTypes.STRING, allowNull: false },
    type: { type: DataTypes.STRING, allowNull: false }, // e.g. toilet, panggung, dll
  });
  return Location;
};
