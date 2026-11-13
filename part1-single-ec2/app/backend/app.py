
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

students = []

@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Flask Backend is running!",
        "status": "success"
    })

@app.route("/students", methods=["GET"])
def get_students():
    return jsonify(students)

@app.route("/students", methods=["POST"])
def add_student():
    data = request.get_json()

    if not data or not data.get("name") or not data.get("email"):
        return jsonify({
            "error": "Name and email are required"
        }), 400

    student = {
        "id": len(students) + 1,
        "name": data["name"],
        "email": data["email"]
    }

    students.append(student)

    return jsonify({
        "message": "Student registered successfully!",
        "student": student
    }), 201

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
