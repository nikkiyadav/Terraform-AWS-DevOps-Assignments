
const express = require("express");
const path = require("path");

const app = express();
const PORT = 3000;

// Flask backend URL
const BACKEND_URL = process.env.BACKEND_URL || "http://127.0.0.1:5000";

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// Check Express status
app.get("/health", (req, res) => {
    res.json({
        message: "Express frontend is running!",
        status: "success"
    });
});

// Get students from Flask
app.get("/api/students", async (req, res) => {
    try {
        const response = await fetch(`${BACKEND_URL}/students`);
        const data = await response.json();

        res.status(response.status).json(data);
    } catch (error) {
        console.error("Backend connection error:", error.message);
        res.status(500).json({
            error: "Unable to connect to Flask backend"
        });
    }
});

// Register student through Flask
app.post("/api/students", async (req, res) => {
    try {
        const response = await fetch(`${BACKEND_URL}/students`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(req.body)
        });

        const data = await response.json();

        res.status(response.status).json(data);
    } catch (error) {
        console.error("Backend connection error:", error.message);
        res.status(500).json({
            error: "Unable to connect to Flask backend"
        });
    }
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Express frontend running on port ${PORT}`);
});
