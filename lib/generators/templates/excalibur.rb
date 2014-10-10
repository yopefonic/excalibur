# Use this to set up your default
Excalibur.configure do |config|
  # ==> Your sane defaults:

  # => Title content
  # config.title.update_content :prefix, 'prefix - '
  config.title.update_content :body, 'My website has a title by Excalibur'

  # => Title options
  # config.title.update_option :length, 69
  # config.title.update_option :omission, '...'
  # config.title.update_option :separator, ''

  # => Description content
  config.description.update_content :body, 'Excalibur gave me a description!'

  # => Description options
  # config.description.update_option :length, 155
  # config.description.update_option :omission, '...'
  # config.description.update_option :separator, ' '

  # => Meta tags
  config.set_meta_tag :name, :viewport, 'width=device-width, initial-scale=1'

  # ==> Configuration DSL:
  #
  # Both the title and description are configurable in the same way;
  # config.title for the title and config.description for the description.
  # They both consist out of three elements; content, options and the
  # combinator. The meta tags have their own interface as they are slightly
  # different. Both the content in the title/description and the content in
  # the meta tags can be given a Proc in order for on-render computation to
  # occur.

  # => Title/Description content
  # The default of the gem tries to combine 3 parts; :prefix,
  # :body and :suffix. They are put together in that order by the default
  # combinator.
  #
  # To set these add:
  # config.title.update_content :prefix, 'CNN.com - '
  # config.title.update_content :body, 'Breaking, World, Business, Sports and
  # Entertainment News'
  #
  # this will result in a title like 'CNN.com - Breaking, World, Business,
  # Sports and Entertainment News'
  #
  # > Title Defaults:
  # prefix: ''
  # body: 'Excalibur'
  # suffix: ''
  #
  # > Description Defaults:
  # prefix: ''
  # body: 'Excalibur; a worthy title for a gem about titles.'
  # suffix: ''

  # => Title/Description options
  # The default of the gem uses the options to truncate the content
  # components in the correct way. :length is the length the content will be
  # truncated to. :omission is used to indicate that the content is truncated
  # and is added behind the section that has been truncated. :separator
  # determines if truncation happens on a character or not,
  # '' for every letter and ' ' for a space as it allows for breaking on words
  # or characters.
  #
  # To set these add:
  # config.title.update_option :length, 42
  # config.title.update_option :omission, '... (continued)'
  #
  # > Title Defaults:
  # length: 69
  # omission: '...'
  # separator: ''
  #
  # > Description Defaults:
  # length: 155
  # omission: '...'
  # separator: ' '

  # => Title/Description combinator
  # The combinator is by default a proc that combines the content elements
  # together and truncates them according to what the options have specified.
  # If your not into it yet the combinator is to be changed with caution.
  #
  # Change the combinator by:
  # config.title.update_combinator(
  #     proc do |object|
  #       # your code here
  #       #
  #       # the object var is passed when rendering and contains an object
  #       # with the current configuration for that render. It's advised when
  #       # using data from that configuration to use object.configuration to
  #       # access it.
  #     end
  # )
  #
  # > Default behavior
  # By default the combinator takes the 3 content sections but only truncates
  # the :body section. This does take into account the length of the :prefix
  # and :suffix when truncating the content so the overall length of the
  # title stays within the length set in the options.
  #
  # > Title/Description configuration examples:
  # content:
  #   prefix: 'Excalibur | '
  #   body: 'The Object oriented way of setting SEO and meta information'
  # options:
  #   length: 69
  #   omission: '...'
  #   separator: ''
  # result: 'Excalibur | The Object oriented way of setting SEO and meta
  #     inform...'
  #
  # options:
  #   separator: ' '
  # result: 'Excalibur | The Object oriented way of setting SEO and meta...'
  #
  # content:
  #   body: 'Just another website'
  #   suffix: ' - site ID'
  # result: 'Just another website - site ID'

  # => Meta tags
  # Meta tags are basically represented in the configuration as a double
  # layered hash. The hash is converted to meta tags types and the values are
  # the content of the meta tag.
  #
  # These can be easily set using:
  # config.set_meta_tag(
  #     :name,
  #     :viewport,
  #     'width=device-width, initial-scale=1')

  # => General configuration:
  # it is possible to roll your own configuration without using the accessors
  # provided in the DSL. You can use the Excalibur::Configuration class to
  # create your own config. Have a look at the code how to do so!
  #
  # you can set it by simply:
  # config = MyCustomConfiguration.new
  #
  # If you want to keep using parts of the default configuration but want to
  # replace others configuration has a #merge! method to merge another
  # Excalibur::Configuration object into the default. Note that this will only
  # work if the supplied object is a Excalibur::Configuration or an inherited
  # object.
  #
  # use this by:
  # config.merge!(MyCustomConfiguration.new)
end
