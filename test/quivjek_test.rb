require File.expand_path("../test_helper", __FILE__)
require 'minitest/mock'
require 'minitest/unit'

class QuivjekTest < Minitest::Test
  def setup
    @dir      = File.expand_path(File.dirname(__FILE__))
    @quivjek  = Quivjek.new(self.get_site_mock)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Quivjek::VERSION
  end

  def test_load_posts_from_quiver
    @quivjek.load_posts_from_quiver()

    # verify the expected markdown and image files were created
    post1  = @dir + '/resources/_posts/quiver/2016-09-14-this-is-an-example-post.md'
    post2  = @dir + '/resources/_posts/quiver/2016-12-12-this-is-an-example-post-with-front-matter.md'
    post3  = @dir + '/resources/_posts/quiver/2016-09-14-this-this-post-is-a-draft.md'
    image1 = @dir + '/resources/images/q/big-claw-puppy-on-wood-floor.jpg'
    image2 = @dir + '/resources/images/q/dog-rides-with-human-on-bicycle-in-japan.jpg'
    assert File.exist?(post1)
    assert File.exist?(post2)
    assert File.exist?(image1)
    assert File.exist?(image2)
    assert_equal false, File.exist?(post3)

    # verify the image urls within the post were modified
    post1_content = File.read(post1)
    assert post1_content.include? "![big-claw-puppy-on-wood-floor.jpg](/images/q/big-claw-puppy-on-wood-floor.jpg)"
    assert post1_content.include? "![dog-rides-with-human-on-bicycle-in-japan.jpg](/images/q/dog-rides-with-human-on-bicycle-in-japan.jpg)"

  end

  def test_load_post_metadata
    path  = @dir +  '/resources/example.qvnotebook/761ED65C-FE71-44A3-989C-0A8EA3C7F781.qvnote'
    metajson = @quivjek.load_meta_json(path)
    result = @quivjek.set_default_frontmatter({}, metajson)
    assert_equal ['one', 'another one'], result["tags"]
  end

  def get_site_mock()

    mock = MiniTest::Mock.new

    # mock expects:
    #            method      return  arguments
    #-------------------------------------------------------------
    mock.expect(:key?,  ['123'], ['notebook_dir'])
    mock.expect(:source, @dir + '/resources')
    mock.expect(:config, mock)
    mock.expect(:[], @dir + '/resources/example.qvnotebook', ['notebook_dir'])
    mock.expect(:config, mock)

    return mock
  end
end
