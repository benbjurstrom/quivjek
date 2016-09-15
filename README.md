# Quivjek: A Jekyll plugin for seamless publication of Quiver notebooks
[![Build Status](https://travis-ci.org/benbjurstrom/quivjek.svg?branch=master)](https://travis-ci.org/benbjurstrom/quivjek)

Quivjek is a Jekyll plugin that automatically exports all notes from a specified Quiver notebook to your _posts folder when the jekyll build command is run. Quivjek also copies and properly links any images contained in a Quiver note to your Jekyll images folder.

## Installation
1. Install the quivjek gem
```
gem install quivjek
```
2. Add quivjek to the gems array found in the _config.yml file.
```
#jekyll_dir/_config.yml
gems: [quivjek]
```
3. Point quivjek to the Quiver notebook of choice by adding the `notebook_dir:` key to the \_config.yml file with a value equal to your notebooks file path. For example:
```
#jekyll_dir/_config.yml
notebook_dir:~/Dropbox/Quiver/Quiver.qvlibrary/14F2BCE0-1B08-4ED6-993A-17C8AB0316E2.qvnotebook
```

To determine a notebook's filepath right click on the note in the Quiver sidebar and choose open in finder. Be aware that Quiver notebooks are folders ending in the .qvnotebook extension and named with a random UUID as in the example above.

## Usage
Simply run `jekyll build` and quivjek will automatically add your Quiver notes to your jekyll site

## Things you should know
All quiver notes must be entirely composed of markdown or code cells.

Quivjek will ignore any posts tagged as `draft`

Quivjek sets the post created date based on the note's created date. Currently there's no easy way to modify the note's create date in Quiver short of modifying the timestamp in the note's meta.json file. Eventually I'd like to allow overriding this value through custom frontmatter.

Quivjek currently copies all notes and images to the jekyll directory within the subfolders `/_posts/quiver` and `/images/q` respectivly. On build quivjek deletes all files from these subfolders and re-copies the notes and images from the Quiver notebook. This is done to clean up any deleted or renamed items. Eventually I'd like to save a manafest and only update the notes and images that have been modified or deleted since the last build.

When an image is added to a markdown cell, Quiver renames the file and sets the original file name as the image tag's alt attribute. For example the image `big-claw-puppy-on-wood-floor.jpg` becomes `![big-claw-puppy-on-wood-floor.jpg](quiver-image-url/642370E09A291BC1601CFD68B44A5C16.jpg)`. For SEO purposes quivjek reverses this process by renaming the image to whatever is found in your alt tag. Therefore it is recormended your alt tags are lowercase, slug-ified, unique, and end in the image file extension.

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
This is my first time using Ruby so bug reports and pull requests are very welcome on GitHub at https://github.com/benbjurstrom/quivjek. Thanks to Bradley Curran's [quiver2jekyll](https://github.com/bradley-curran/quiver2jekyll/) for providing some of the code needed to get started.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).