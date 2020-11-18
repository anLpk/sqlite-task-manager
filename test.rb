require "sqlite3"
DB = SQLite3::Database.new("tasks.db")
DB.results_as_hash = true
require_relative "task"


# Destroy all the tasks
Task.all.each { |task| task.destroy }

# all_tasks = Task.all
# p all_tasks

# first_task = Task.find(1)
# p first_task
