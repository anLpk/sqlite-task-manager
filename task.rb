require 'pry-byebug'

class Task
  attr_accessor :title, :done

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @description = attributes[:description]
    @done = attributes[:done]
  end

  def self.all
    query = "SELECT * FROM tasks"
    results = DB.execute(query)
    results.map do |task_hash|
      build_task(task_hash)
    end
  end

  def self.find(id)
    result = DB.execute("SELECT * FROM tasks WHERE id = ?", id)
    if result.empty?
      return nil
    else
      return build_task(result[0])
    end
  end

  def save
    if @id.nil?
      DB.execute("INSERT INTO tasks (title, description) VALUES (?, ?)", @title, @description)
      @id = DB.last_insert_row_id #last id
    else
      done_to_integer = (@done == true) ? 1 : 0
      DB.execute("UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?", @title, @description, done_to_integer, @id )
    end
  end


  def self.destroy_all
    DB.execute("DELETE FROM tasks")
  end


  def destroy
    DB.execute("DELETE FROM tasks WHERE id = ?", @id)
  end


  private

  def self.build_task(task_hash)
    id = task_hash["id"]
    title = task_hash["title"]
    description = task_hash["description"]
    done = task_hash["done"] == 1
    Task.new(id: id, title: title, description: description, done: done)
  end
end
