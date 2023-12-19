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
