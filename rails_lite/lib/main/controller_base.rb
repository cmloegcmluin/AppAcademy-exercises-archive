require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './session'
require_relative './router'
require_relative './params'

class ControllerBase
  attr_reader :req, :res
  attr_reader :params
  attr_accessor :already_built_response

  def initialize(req, res, route_params = {})
    @params = Params.new(req, route_params)
    @req, @res = req, res
    @already_built_response = false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    only_render_once!
    self.res.status = 302
    self.res.header["location"] = url
    session.store_session(@res)
  end

  def render_content(content, type)
    only_render_once!
    self.res.content_type = type
    self.res.body = content
    session.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    content = ERB.new(template).result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end

  private

  def only_render_once!
    fail if already_built_response?
    self.already_built_response = true
  end
end
