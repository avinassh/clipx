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

    # Remove all disallowed attributes
    node.attribute_nodes.each do |attr_node|
      # Get the attribute name if we have a namespace
      attr_name = if attr_node.namespace
        "#{attr_node.namespace.prefix}:#{attr_node.node_name}"
      else
        attr_node.node_name
      end
      if @@dtd['disallowed_attributes'].include? attr_name
        attr_node.remove
      end
    end

    # This is lifted from the strip scrubber in
    # Loofah. It replaces the node with its contents
    unless @@dtd['allowed_tags'].include? node.name
      node.before node.children
      node.remove
    end

    # Remove any empty tags
    if node.inner_text == ''
      node.remove
      Loofah::Scrubber::STOP
    end
  end
end