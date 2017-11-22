require 'test_helper'

class Transposon::ParserTest < Minitest::Test
  def setup
    @ghapi = File.read(File.join(fixtures_dir, 'gh-schema.graphql'))
    @swapi = File.read(File.join(fixtures_dir, 'sw-schema.graphql'))
    @swparser = Transposon::Parser.new(@swapi)
    @swresults = @swparser.parse
  end

  def test_that_it_understands_operations
    assert_equal %i(query), @swresults.operations.keys

    assert @swresults.operations[:query][:hero]
    assert_equal [{ episode: { required: false }}], @swresults.operations[:query][:hero][:arguments]

    assert @swresults.operations[:query][:human]
    assert_equal [{ id: { required: true }}], @swresults.operations[:query][:human][:arguments]

    assert @swresults.operations[:query][:droid]
    assert_equal [{ id: { required: true }}], @swresults.operations[:query][:droid][:arguments]
  end
end
