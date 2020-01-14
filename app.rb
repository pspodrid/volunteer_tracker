require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
also_reload('lib/**/*.rb')
require('./lib/song')
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get('/') do
  @projects = Project.all
  erb(:projects)
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

get('/projects/new') do
  erb(:new_project)
end

post('/projects') do
  name = params[:project_name]
  project = Project.new(name, nil)
  project.save
  @projects = Project.all
  erb(:projects)
end

get('/project/:id') do
  @project = Project.find(params[:id].to_i)
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb(:edit_project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.update(params[:name])
  @projects = Project.all
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.delete
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  erb(:volunteer)
end

post('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i())
  volunteer = Volunteer.new(params[:volunteer_name], @project.id, nil)
  volunteer.save()
  erb(:project)
end

# Edit a song and then route back to the album view.
patch('/projects/:id/volunteers/:volunteer_id') do
  @project = Projects.find(params[:id].to_i())
  volunteer = Volunteer.find(params[:volunteer_id].to_i)
  volunteer.update(params[:name], @project.id)
  erb(:project)
end

# Delete a song and then route back to the album view.
delete('/projects/:id/volunteer/:volunteer_id') do
  volunteer = Volunteer.find(params[:volunteer_id].to_i)
  volunteer.delete
  @project = Project.find(params[:id].to_i)
  erb(:project)
end
