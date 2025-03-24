// server.js
const express = require('express');
const axios = require('axios');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const STEAM_API_KEY = 'YOUR_STEAM_API_KEY'; // Replace with your Steam API key

app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/games', async (req, res) => {
    try {
        const response = await axios.get(`https://api.steampowered.com/ISteamApps/GetAppList/v2/`);
        const games = response.data.applist.apps;
        res.json(games);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch data from Steam API' });
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
