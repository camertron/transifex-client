module Transifex
  autoload :Client,     'transifex/client'
  autoload :Config,     'transifex/config'
  autoload :Error,      'transifex/error'
  autoload :Middleware, 'transifex/middleware'
  autoload :Projects,   'transifex/projects'
  autoload :Proxy,      'transifex/proxy'
  autoload :Request,    'transifex/request'
  autoload :Resources,  'transifex/resources'

  extend Config
end
