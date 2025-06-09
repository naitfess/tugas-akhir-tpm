require('dotenv').config();
const express = require('express');
const cors = require('cors'); // Tambahkan ini
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
  origin: '*', // Allow all origins in development
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
})); // Tambahkan ini
app.use(express.json());
app.use('/uploads', express.static(require('path').join(__dirname, 'public/uploads')));

const db = require('./models');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const organizerRoutes = require('./routes/organizerRoutes');
const adminRoutes = require('./routes/adminRoutes');
const eventRoutes = require('./routes/eventRoutes');
const locationRoutes = require('./routes/locationRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/organizer', organizerRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/event', eventRoutes);
app.use('/api/location', locationRoutes);

// Sync DB
if (process.env.NODE_ENV !== 'test') {
  db.sequelize.sync().then(() => {
    console.log('Database synced');
  }).catch(err => {
    console.error('DB sync error:', err);
  });
}

app.get('/', (req, res) => {
  res.send('EventEase Backend is running');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
