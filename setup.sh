#!/bin/bash

# Update package list and install Node.js and npm
echo "Updating package list..."
sudo apt-get update

echo "Installing Node.js and npm..."
sudo apt-get install -y nodejs npm

# Navigate to the project directory
echo "Navigating to project directory..."
cd "$(dirname "$0")"

# Initialize npm and install dependencies
echo "Initializing npm and installing dependencies..."
npm init -y
npm install express axios dotenv

# Create .env file
echo "Creating .env file..."
cat <<EOL > .env
STEAM_API_KEY=YOUR_STEAM_API_KEY
EOL

# Create server.js file
echo "Creating server.js file..."
cat <<EOL > server.js
const express = require('express');
const axios = require('axios');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const STEAM_API_KEY = process.env.STEAM_API_KEY;

app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/games', async (req, res) => {
    try {
        const response = await axios.get(\`https://api.steampowered.com/ISteamApps/GetAppList/v2/\`);
        const games = response.data.applist.apps;
        res.json(games);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch data from Steam API' });
    }
});

app.listen(PORT, () => {
    console.log(\`Server is running on port \${PORT}\`);
});
EOL

# Create public directory and index.html file
echo "Creating public directory and index.html file..."
mkdir -p public
cat <<EOL > public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Steam Catalog</title>
</head>
<body>
    <h1>Steam Catalog</h1>
    <ul id="game-list"></ul>

    <script>
        async function fetchGames() {
            try {
                const response = await fetch('/api/games');
                const games = await response.json();
                const gameList = document.getElementById('game-list');
                games.forEach(game => {
                    const listItem = document.createElement('li');
                    listItem.textContent = game.name;
                    gameList.appendChild(listItem);
                });
            } catch (error) {
                console.error('Failed to fetch games:', error);
            }
        }

        fetchGames();
    </script>
</body>
</html>
EOL

# Run the server
echo "Starting the server..."
node server.js
