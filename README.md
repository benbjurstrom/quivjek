#Quivjek: A Jekyll plugin for seamless publication of Quiver notebooks
Quivjek is a Jekyll plugin that automatically copies a specified Quiver notebook to your Jekyll _posts folder whenever the jekyll build command runs. Quivjek also copies and properly links any images contained in a Quiver note to your Jekyll images folder.

## Installation
1. Install the quivjek gem
```
gem install quivjek
```
2. In jekyll's \_config.yml file add quivjek to the gems array
```
gems: [quivjek]
```
3. Point quivjek to the Quiver notebook of choice by adding the `notebook_dir:` key in jekyll's \_config.yml file and set the value equal to the path to your chosen Quiver notebook. For example:
```
#jekyll _config.yml
notebook_dir:~/Dropbox/Quiver/Quiver.qvlibrary/14F2BCE0-1B08-4ED6-993A-17C8AB0316E2.qvnotebook
```

## Usage
Simply run ```jekyll build``` and quivjek will automatically add your Quiver notes to your jekyll site.

## How to I find my quiver notebook?
Your Quiver notebook is contained within your Quiver library. Your Quiver library is a folder that ends with the extension .qvlibrary. You can find the location of your Quiver library in Quiver's menu by going under Quiver -> Preferences -> Sync and checking the Library Location. If using the command line you can cd into it like normal. If using finder, right click on the .qvlibrary and click show package contents.

Now that you're inside your Quiver libary folder you should see all of that libary's notebooks. Quiver notebooks are folders that end with the .qvnotebook extension. They will be named with a UUID as indiacted above. To determine the Quiver notebook's name check the meta.json file contained within each .qvnotebook folder.

## Other info
All quiver notes must be entirely composed of markdown or code cells.

Quivjek will ignore any posts tagged as `draft`

Quivjek sets the post created date based on the Quiver created date. Currently there's no easy way to modify the Quiver create date short of modifying the timestamp in the note's meta.json file. Eventually I'd like to allow overriding this value through custom fronmatter.

Quivjek currently copies all notes and images to the subfolders `/_posts/quiver` and `/images/q` respectivly. On build quivjek deletes all files from these subfolders and re-copies the notes and images from the Quiver notebook. This is done to clean up any deleted or renamed items. Eventually I'd like to save a manafest and only update the notes and images that have changed or been removed since the last build.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benbjurstrom/quivjek. This is my first time using ruby so pull requests to improve code style are welcome. Thanks to Bradley Curran's [quiver2jekyll](https://github.com/bradley-curran/quiver2jekyll/) package for pointing me in the right direction.



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).