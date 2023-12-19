from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Sample data for demonstration purposes
tasks = [
    {"id": 1, "title": "Buy groceries", "completed": False},
    {"id": 2, "title": "Learn Flask", "completed": True},
    {"id": 3, "title": "Build ToDo app", "completed": False},
]

# Route to display tasks
@app.route('/')
def index():
    return render_template('index.html', tasks=tasks)

# Route to add a new task
@app.route('/add', methods=['POST'])
def add():
    new_task_title = request.form.get('newTask')
    if new_task_title:
        new_task = {
            "id": len(tasks) + 1,
            "title": new_task_title,
            "completed": False
        }
        tasks.append(new_task)
    return redirect(url_for('index'))

# Route to mark a task as completed
@app.route('/complete/<int:task_id>')
def complete(task_id):
    task = next((task for task in tasks if task['id'] == task_id), None)
    if task:
        task['completed'] = not task['completed']
    return redirect(url_for('index'))

# Route to delete a task
@app.route('/delete/<int:task_id>')
def delete(task_id):
    global tasks
    tasks = [task for task in tasks if task['id'] != task_id]
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
This example assumes you have a templates folder in the same directory as your main script (app.py in this case). In that templates folder, create an HTML file named index.html with the following content:

html
Copy code
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ToDo App</title>
</head>
<body>
    <h1>ToDo App</h1>
    
    <form action="/add" method="POST">
        <label for="newTask">New Task:</label>
        <input type="text" id="newTask" name="newTask" required>
        <button type="submit">Add Task</button>
    </form>

    <ul>
        {% for task in tasks %}
            <li>
                {{ task.title }}
                <a href="/complete/{{ task.id }}">Mark as {{ "Incomplete" if task.completed else "Complete" }}</a>
                <a href="/delete/{{ task.id }}">Delete</a>
            </li>
        {% endfor %}
    </ul>
</body>
</html>
