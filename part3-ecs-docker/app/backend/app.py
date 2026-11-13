
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

students = []


# Health check used by AWS Application Load Balancer
@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Flask Backend is running!",
        "status": "success"
    })


# GET: Retrieve all students
# Support both old and new API paths
@app.route("/students", methods=["GET"])
@app.route("/api/students", methods=["GET"])
def get_students():
    return jsonify(students)


# POST: Register a new student
@app.route("/students", methods=["POST"])
@app.route("/api/students", methods=["POST"])
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
    app.run(host="127.0.0.1", port=5001, debug=False)
