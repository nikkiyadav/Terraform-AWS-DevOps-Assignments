
const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Serve frontend HTML, CSS and JavaScript
app.use(express.static(path.join(__dirname, "public")));

// Health check used by AWS Load Balancer
app.get("/health", (req, res) => {
    res.json({
        message: "Express frontend is running!",
        status: "success"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Express frontend running on port ${PORT}`);
});
