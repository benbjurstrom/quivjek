#!/usr/bin/ruby
require "date"
require "json"
require "fileutils"
require "quivjek/version"
require "jekyll"
require "front_matter_parser"
require "yaml"

Jekyll::Hooks.register :site, :after_init do |site|
  q = Quivjek.new(site)
  q.load_posts_from_quiver
end

class Quivjek

  def initialize( site )
    self.showhelp('The qivjek plugin requires notebook_dir be set in your _config.yml file') unless site.config.key?('notebook_dir')

    @site         = site
    @jekyll_dir   = site.source
    @notebook_dir = site.config['notebook_dir']
    @post_dir     = File.join(@jekyll_dir, "/_posts/quiver")
    @img_dir      = File.join(@jekyll_dir, "/images/q")

  end

  def load_posts_from_quiver()

    Dir.mkdir(@post_dir) unless File.exists?(@post_dir)
    Dir.mkdir(@img_dir) unless File.exists?(@img_dir)

    # Clear out the _posts/quiver and images/q directories in case any posts or images have been renamed
    FileUtils.rm_rf Dir.glob(@post_dir + '/*')
    FileUtils.rm_rf Dir.glob(@img_dir + '/*')

    # Pass the path of each .qvnote to the copy_post method
    Dir.foreach(@notebook_dir) do |item|
      next if item == '.' or item == '..' or item == 'meta.json' or item == '.keep'
      self.copy_note(File.join(@notebook_dir, item))
    end

  end

  def showhelp(message)
    puts message.red + "\n"
    exit
  end

  def copy_note(note_dir)
    # Load the quiver note meta.json file.
    metajson = load_meta_json(note_dir)

    # Skip this note if tagged with draft
    metajson["tags"].each do |tag|
      return if tag == 'draft'
    end

    # Copy the notes images to the jekyll directory
    imagepath    = File.join(note_dir, "resources")
    self.copy_note_images(imagepath) if File.exist?(imagepath)

    # Load the quiver note content.json file and merge its cells.
    contentjson = load_content_json(note_dir)
    content     = self.merge_cells(contentjson, '')

    # Parse out optional frontmatter from the content
    parsed      = FrontMatterParser.parse(content)
    fm          = parsed.front_matter
    content     = parsed.content

    # Set some default frontmatter and combine with content
    fm = set_default_frontmatter(fm, metajson)
    output = fm.to_yaml + "---\n" + content

    # Write the markdown file to the jekyll dir
    filename    = self.get_filename(fm)
    File.open(File.join(@post_dir, filename), "w") { |file| file.write(output) }

  end

  def load_meta_json(dir)
    metapath    = File.join(dir, "meta.json")
    showhelp("meta.json doesn't exist") unless File.exist? metapath
    metajson = JSON.parse(File.read(metapath))

    return metajson
  end

  def load_content_json(dir)
    contentpath = File.join(dir, "content.json")
    showhelp(contentpath + "content.json doesn't exist") unless File.exist? contentpath
    contentjson = JSON.parse(File.read(contentpath))

    return contentjson
  end

  def copy_note_images(imagepath)

    # copy all images from the note's resources dir to the jekyll images/q dir
    Dir.foreach(imagepath) do |item|
      next if item == '.' or item == '..'
      FileUtils.cp(File.join(imagepath, item), @img_dir)
    end

  end

  def get_filename(fm)
    title = fm["title"].gsub(" ", "-").downcase
    date = DateTime.parse(fm["date"])

    day = "%02d" % date.day
    month = "%02d" % date.month
    year = date.year

    return "#{year}-#{month}-#{day}-#{title}.md"
  end

  def set_default_frontmatter(fm, metajson)

    # If certain frontmatter is missing default to quiver metadata
    fm['title'] = metajson['title']      unless fm['title']

    if !fm.key?("date")
      date = DateTime.strptime(metajson["created_at"].to_s, "%s")
      fm['date'] = date.strftime('%Y-%m-%d')
    end

    fm['tags']  = metajson["tags"]

    return fm

  end

  def merge_cells(contentjson, output)
    contentjson["cells"].each do |cell|
      case cell["type"]
        when "code"
          output << "{% highlight #{cell["language"]} %}\n"
          output << "#{cell["data"]}\n"
          output << "{% endhighlight %}\n"
        when "markdown"

          c = cell["data"]

          # Scan the markdown cell for images
          images = c.scan(/!\[(.*)\]\(quiver-image-url\/(.*)\)/)
          images.each do |image|

            # Modify the image source to point to the alt tag in the images/q/ folder
            c = c.gsub(image[1], image[0])

            # Rename the image (since the image has already been copied from the qvnote folder)
            File.rename(File.join(@img_dir, image[1]), File.join(@img_dir, image[0]))
          end

          output << "#{c.gsub("quiver-image-url", "/images/q")}\n"
        else
          showhelp(frontmatter_title + " :all cells must be code or markdown types")
      end

      output << "\n"

      return output
    end
  end

end