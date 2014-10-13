class Excalibur::<%= class_name %>Decorator < Excalibur::Decorator
  # ==> Full custom configuration
  # it is possible to force a new config onto over the application wide
  # default set in the initializer.
  #
  # You can pass a custom configuration in like so:
  # excalibur_init @my_custom_config
  #
  # or start with a blank configuration like so:
  # excalibur_init Excalibur::Configuration.new
  #
  # The last method is easiest as all configuration options are available in
  # this decorator through a DSL instead of building the object from scratch.

  # ==> Title and Description settings
  # Titles and descriptions act mostly the same way within Excalibur. They
  # share the same DSL with the small difference in method name. Below the
  # description is for title but it applies to description as well.
  #
  # => Set content
  # the excalibur_set_title_content method takes two parameters to change the
  # content of a title. By defaults you can set a :prefix, :body and :suffix.
  # All of these can be a string or a Proc.
  #
  # as an example:
  # excalibur_set_title_content :body, 'my class specific title body'
  #
  # => Set option
  # the excalibur_set_title_option method takes two arguments to change the
  # options of a title. By defaults you can set a :length, :omission and
  # :separator.
  #
  # :length takes any integer to indicate the length limit of the title.
  # :omission is what fills the end of the line when the body is truncated
  # below the limited length of the title :body.
  # :separator determines what character the :body will be truncated on. with
  # a single space (' ') it will break on words and with no-space ('') it
  # will break on any character.
  #
  # as an examples:
  # excalibur_set_title_content :length, 42
  # excalibur_set_title_content :omission, '... (continued)'
  #
  # => set combinator
  # the excalibur_set_title_combinator takes one argument and it should be a
  # Proc. The proc is passed the decorated object so you have access to the
  # object and the configuration of required. It needs to result in a string.
  #
  # excalibur_set_title_combinator(proc { |obj|
  #   # your code here
  # })

  # ==> Meta tag settings
  # the excalibur_set_meta_tag method takes three arguments to set the content
  # for a meta tag. The first and second arguments are about the type of meta
  # tag while the third is used for the content.
  #
  # A description meta tag would look like this:
  # excalibur_set_meta_tag :name, :description, 'Some description content'
  #
  # The content of a meta tag can be anything that prints nicely into a
  # string, a Proc or an Array. The Proc may also result in an array and is
  # passed the decorated object for access to the objects attributes and the
  # excalibur configuration acting for the object.

  # ==> Recommended use
  # Because the title, description and the meta tags all allow for a Proc to
  # be passed it gives you a lot of freedom. However like any freedom it is to
  # be used with some warning. It is recommended when doing larger amounts of
  # work in code of a proc to use the decorator to delegate that
  # responsibility. The decorator becomes easier to test and it is also a lot
  # cleaner.
  #
  # read more about how to use decorators with procs properly:
  # https://github.com/yopefonic/excalibur/wiki/Advised-usage-of-proc%27s
end
