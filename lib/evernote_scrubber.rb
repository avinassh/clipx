class EvernoteScrubber < Loofah::Scrubber
  @@dtd = YAML.load_file Rails.root.join('lib','assets','enml2.yml')

  def initialize
    @direction = :bottom_up

  end

  def scrub(node)
    # Remove all disallowed tags
    if @@dtd['disallowed_tags'].include? node.name
      node.remove
      Loofah::Scrubber::STOP # don't bother with the rest of the subtree
    end

    # This is lifted from the strip scrubber in
    # Loofah. It replaces the node with its contents
    unless @@dtd['allowed_tags'].keys.include? node.name
      node.before node.children
      node.remove
      stripped = true
    end

    # Remove all disallowed attributes
    unless stripped
      valid_attributes = @@dtd['allowed_tags'][node.name]
      node.attribute_nodes.each do |attr_node|
        # Get the attribute name if we have a namespace
        attr_name = if attr_node.namespace
          "#{attr_node.namespace.prefix}:#{attr_node.node_name}"
        else
          attr_node.node_name
        end
        unless valid_attributes.include? attr_name
          attr_node.remove
        end
      end
    end


    # Remove any empty tags
    # This basically makes sure that a tag is considered empty iff
    # 1. Its inner text is blank
    # 2. It has no children
    # 3. Its not a valid void tag (like br,hr)
    if node.inner_text == '' and @@dtd['valid_void_tags'].exclude? node.name and node.children.size == 0
      node.remove
      Loofah::Scrubber::STOP
    end
  end

  def self.dtd
    @@dtd
  end
end