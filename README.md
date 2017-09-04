# Quivjek: A Jekyll plugin for seamless publication of Quiver notebooks
[![Build Status](https://travis-ci.org/benbjurstrom/quivjek.svg?branch=master)](https://travis-ci.org/benbjurstrom/quivjek)

Quivjek is a [Jekyll](https://jekyllrb.com/) plugin that automatically exports all notes from a specified [Quiver](http://happenapps.com/#quiver) notebook to your _posts folder when the jekyll build command is run. Quivjek also copies and properly links any images contained in a Quiver note to your Jekyll images folder.

## Installation
1. Install the quivjek gem
  ```bash
  gem install quivjek
  ```
2. Add quivjek to the gems array found in the _config.yml file.
  ```yaml
  #jekyll_dir/_config.yml
  gems: [quivjek]
  ```
3. Point quivjek to the Quiver notebook of choice by adding the `notebook_dir:` key to the \_config.yml file with a value equal to your notebooks file path. For example:
  ```yaml
  #jekyll_dir/_config.yml
  notebook_dir:~/Dropbox/Quiver/Quiver.qvlibrary/14F2BCE0-1B08-4ED6-993A-17C8AB0316E2.qvnotebook
  ```

To determine a Quiver notebook's filepath right click on the note in the Quiver sidebar and choose open in finder. Be aware that Quiver notebooks are folders ending in the .qvnotebook extension and named with a random UUID as in the example above.

## Usage
Run `jekyll build` and quivjek will automatically copy your Quiver notes to your jekyll _posts folder prior to build.

## Things you should know
1. All quiver notes must be entirely composed of markdown or code cells.

1. Quivjek will ignore any posts tagged as `draft`

1. Optionally you can include a YAML front matter envelope to your Quiver note.

  ```yaml
  
  ---
  title: This is an example post
  date: '2016-09-14'
  ---
  
  Some content...
  ```

  * By default Quivjek sets the front matter date (and markdown file name) based on the Quiver note's created date metadata. This can be overridden by adding the date front matter to your Quiver note.

  * By default Quivjek sets the front matter title (and markdown file name) equal to the Quiver note's title. This can be overridden by adding the title front matter to your quiver note.

  * By default Quivjek adds the Quiver note's tags as front matter tags.

1. Quivjek currently copies all notes and images to the jekyll directory within the subfolders `/_posts/quiver` and `/images/q` respectively. On build quivjek deletes all files from these subfolders and re-copies the notes and images from the Quiver notebook. This is done to clean up any deleted or renamed items. Eventually I'd like to save a manifest and only update the notes and images that have been modified or deleted since the last build.

1. When an image is added to a markdown cell, Quiver renames the file and sets the original file name as the image tag's alt attribute. For example the image `big-claw-puppy-on-wood-floor.jpg` becomes `![big-claw-puppy-on-wood-floor.jpg](quiver-image-url/642370E09A291BC1601CFD68B44A5C16.jpg)`. For SEO purposes quivjek reverses this process by renaming the image to whatever is found in your alt tag. Therefore it is recommended your alt tags are lowercase, slug-ified, unique, and end in the image file extension.

1. You can prevent quivjek from running by setting  ENV['APP_ENV'] = 'production'

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
This is my first time using Ruby so bug reports and pull requests are very welcome on GitHub at https://github.com/benbjurstrom/quivjek. Thanks to Bradley Curran's [quiver2jekyll](https://github.com/bradley-curran/quiver2jekyll/) for providing some of the code needed to get started.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).