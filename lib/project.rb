class Project
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exe("INSERT INTO projects (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def update(name)
    @name = name
    DB.exec("UPDATE projects SET name ='#{@name}' WHERE id = #{@id};")
  end

  def ==(project_to_compare)
    self.name == project_to_compare.name && self.id == project_to_compare.id
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      name = project.fetch("name")
      id = project.fetch("id").to_i
      projects.push(Project.new({:name => name, :id => id}))
    end
    projects
  end

  def self.clear
    DB.exec("DELETE FROM projects *;")
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    name = project.fetch("name")
    id = project.fetch("id").to_i
    Project.new({:name =>, :id => id})
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
    DB.exec("DELETE FROM volunteers WHERE project_id = #{@id}")
  end

  def volunteers
    Volunteer.find_by_project(self.id)
  end
end
