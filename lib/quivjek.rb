#!/usr/bin/ruby
require "date"
require "json"
require "fileutils"
require "quivjek/version"
require "jekyll"

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

  protected

  def showhelp(message)
    puts message.red + "\n"
    exit
  end

  def copy_note(note_dir)
    metapath    = File.join(note_dir, "meta.json")
    contentpath = File.join(note_dir, "content.json")
    imagepath   = File.join(note_dir, "resources")

    showhelp("meta.json doesn't exist") unless File.exist? metapath
    metajson = JSON.parse(File.read(metapath))

    # Skip this note if tagged with draft
    metajson["tags"].each do |tag|
      return if tag == 'draft'
    end

    showhelp(contentpath + "content.json doesn't exist") unless File.exist? contentpath

    self.copy_note_images(imagepath) if File.exist?(imagepath)

    filename = self.get_filename(metajson)
    output   = self.add_frontmatter(metajson)

    contentjson = JSON.parse(File.read(contentpath))
    output      = self.add_content(contentjson, output)

    File.open(File.join(@post_dir, filename), "w") { |file| file.write(output) }
  end

  def copy_note_images(imagepath)

    # copy all images from the note's resources dir to the jekyll images/q dir
    Dir.foreach(imagepath) do |item|
      next if item == '.' or item == '..'
      FileUtils.cp(File.join(imagepath, item), @img_dir)
    end

  end

  def get_filename(metajson)
    title = metajson["title"].gsub(" ", "-").downcase

    created_at_date = DateTime.strptime(metajson["created_at"].to_s, "%s")
    day = "%02d" % created_at_date.day
    month = "%02d" % created_at_date.month
    year = created_at_date.year

    return "#{year}-#{month}-#{day}-#{title}.md"
  end

  def add_frontmatter(metajson)
    tags   = metajson["tags"].map { |tag| "    - #{tag}" }.join("\n")
    output = <<eos
---
layout: post
title: "#{metajson["title"]}"
eos

    if !tags.empty?
      output << "tags:\n#{tags}\n"
    end

    output << "---\n\n"

    return output
  end

  def add_content(contentjson, output)
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