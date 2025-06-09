module.exports = (sequelize, DataTypes) => {
  const Event = sequelize.define('Event', {
    id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
    name: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.TEXT, allowNull: false },
    category: { type: DataTypes.STRING, allowNull: false },
    date: { type: DataTypes.DATE, allowNull: false },
    longitude: { type: DataTypes.STRING, allowNull: false },
    latitude: { type: DataTypes.STRING, allowNull: false },
    organizerId: { type: DataTypes.INTEGER, allowNull: false },
    time_zone_label: { 
      type: DataTypes.ENUM('WIB', 'WIT', 'WITA', 'London'), 
      allowNull: false, 
      defaultValue: 'WIB' 
    },
    currency: {
      type: DataTypes.ENUM(
        'AUD','BGN','BRL','CAD','CHF','CNY','CZK','DKK','EUR','GBP','HKD','HUF','ILS','INR','ISK','JPY','KRW','MXN','MYR','NOK','NZD','PHP','PLN','RON','SEK','SGD','THB','TRY','USD','ZAR','IDR'
      ),
      allowNull: false,
      defaultValue: 'IDR'
    },
    price: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0
    },
  });
  return Event;
};
