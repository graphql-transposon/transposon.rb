require 'test_helper'

class Transposon::GeneratorTest < Minitest::Test
  def setup
    @ghapi = File.read(File.join(fixtures_dir, 'gh-schema.graphql'))
    @swapi = File.read(File.join(fixtures_dir, 'sw-schema.graphql'))

    @swclient = Transposon::Client.new(schema: @swapi)
  end

  def test_that_it_generates_query
    assert_respond_to @swclient, :query
    assert_equal 'query { }', @swclient.query.build
  end

  def test_that_it_understands_query_root_fields
    assert_equal 'query { hero() { }}', @swclient.query.hero.build

    # bogus arg
    err = assert_raises ArgumentError do
      @swclient.query.hero(lol: 123).build
    end
    assert_equal 'Expected args to match just [:episode], but you also provided [:lol]', err.message

    # real arg
    assert_equal 'query { hero(episode: 4) { }}', @swclient.query.hero(episode: 4).build

    # missing required arg
    err = assert_raises ArgumentError do
      @swclient.query.human.build
    end
    assert_equal 'Required args must be all of [:id], but you did not provide them', err.message

    # provided required arg
    assert_equal 'query { human(id: "123") { }}', @swclient.query.human(id: '123').build
  end
end
