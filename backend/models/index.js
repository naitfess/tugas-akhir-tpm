const Sequelize = require('sequelize');
const sequelize = require('../config/database');

const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;

// Import models
// ...existing code...

db.User = require('./user')(sequelize, Sequelize.DataTypes);
db.Event = require('./event')(sequelize, Sequelize.DataTypes);
db.Location = require('./location')(sequelize, Sequelize.DataTypes);
db.Favorite = require('./favorite')(sequelize, Sequelize.DataTypes);
db.OrganizerRequest = require('./organizerRequest')(sequelize, Sequelize.DataTypes);

// Associations
// ...existing code...

db.User.hasMany(db.Favorite, { foreignKey: 'userId' });
db.Favorite.belongsTo(db.User, { foreignKey: 'userId' });

db.Event.hasMany(db.Favorite, { foreignKey: 'eventId' });
db.Favorite.belongsTo(db.Event, { foreignKey: 'eventId' });

db.User.hasMany(db.OrganizerRequest, { foreignKey: 'userId' });
db.OrganizerRequest.belongsTo(db.User, { foreignKey: 'userId' });

db.User.hasMany(db.Event, { foreignKey: 'organizerId' });
db.Event.belongsTo(db.User, { foreignKey: 'organizerId' });

db.Event.hasMany(db.Location, { foreignKey: 'eventId' });
db.Location.belongsTo(db.Event, { foreignKey: 'eventId' });

module.exports = db;
