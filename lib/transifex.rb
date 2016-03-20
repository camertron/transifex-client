module Transifex
  autoload :Categories, 'transifex/categories'
  autoload :Client,     'transifex/client'
  autoload :Config,     'transifex/config'
  autoload :HttpError,  'transifex/http_error'
  autoload :Middleware, 'transifex/middleware'
  autoload :Projects,   'transifex/projects'
  autoload :Proxy,      'transifex/proxy'
  autoload :Request,    'transifex/request'
  autoload :Resources,  'transifex/resources'

  extend Config
end
