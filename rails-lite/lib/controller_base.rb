require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req, @res = req, res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if @already_built_response
      raise "Cannot double render in this house"
    else
      @already_built_response = true
    end
    @res.status = 302
    @res.location = url
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if @already_built_response
      raise "Cannot double render in this house"
    else
      @already_built_response = true
    end
    @res["Content-Type"] = content_type
    @res.write(content)
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = File.join(File.dirname(File.dirname(__FILE__)), "views", controller_name, template_name.to_s + ".html.erb")
    
    content = File.read(path)
    content = ERB.new(content)
    render_content(content.result(binding), "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

