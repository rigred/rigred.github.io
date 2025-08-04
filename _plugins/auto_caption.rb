# _plugins/auto_caption.rb
#
# Final attempt at a robust auto-captioning plugin.
# It hooks into the build process right after Markdown is converted to HTML.

require 'nokogiri'

Jekyll::Hooks.register :posts, :post_convert do |post|
  # Use .fragment() because at this stage, the content is not a full HTML page yet.
  doc = Nokogiri::HTML.fragment(post.content)

  # Find every <p> tag that contains exactly one <img> child which has an alt attribute.
  doc.css('p > img:only-child[alt]').each do |img|
    alt_text = img['alt']
    p_tag = img.parent

    # Skip if the alt text is empty.
    next if alt_text.nil? || alt_text.strip.empty?

    # Create the new <figure> HTML as a string.
    figure_html = %(
      <figure class="captioned-image">
        #{img.to_html}
        <figcaption>#{alt_text}</figcaption>
      </figure>
    )

    # Replace the parent <p> tag with the new <figure> block.
    p_tag.replace(figure_html)
  end

  # Update the post's content with our modified HTML.
  post.content = doc.to_html
end