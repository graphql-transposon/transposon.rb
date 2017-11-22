$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'transposon'

require 'minitest/autorun'

def fixtures_dir
  File.join(File.dirname(__FILE__), 'transposon', 'fixtures')
end
