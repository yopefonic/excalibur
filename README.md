# Excalibur

Excalibur is a SEO gem for [Ruby on Rails](rubyonrails.org) and helps you to
set the title and meta tags for you site overall and per page. Unlike other
options like [meta-tags](https://github.com/kpumuk/meta-tags) and
[meta_magic](https://github.com/lassebunk/metamagic) Excalibur focusses on
providing an object based DSL to turn the objects you are presenting on the
page into SEO related tags in the head.

## Installation

Add this line to your application's Gemfile:

    gem 'excalibur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install excalibur

### Initialize

To add an initializer to your application execute:

    rails generate excalibur:install

The initializer is documented with the possible options you have to customize
your default setup of Excalibur.

## Usage

### Layout

In your layout you can replace your title tag with the Excalibur render title
method:

```erb
<%= render_title_tag %>
```

To render meta tags place this between the ```<head>``` tags of your layout:

```erb
<%= render_meta_tags %>
```

### Views

As excalibur believes in separation of concerns passing the current object you
want to render title and meta tags for is done in the view.

```erb
<% entitle @your_object %>
```

The object your passing into the entitle method will search for a Excalibur
decorator. You can find out more on how to create them in the
[decorators](#decorators) section.

To modify the configuration in the view you can pass an option into the
```entitle``` method and pass it a new excalibur config object. Read more
about creating your own in the [configurations](#configurations) section. It
will try and merge the supplied configuration with the one specified in the
decorator. Because of this you need to supply it with the same type of object
to make that possible.

Notably the second argument of ```entitle``` can also pass other
[Draper](https://github.com/drapergem/draper) related options like draper's
context.

```ruby
entitle @your_object, config: @custom_config
```

### Decorators

The decorators are what turns your object into data that can be used for the
meta tags and the title. So without a decorator for an object the view helper
``` entitle ``` will have no use at all.

To scaffold a decorator execute:

    rails generate excalibur:install [class name]

A detailed description on how the decorators work can be found in the newly
created decorator class. As a side note the ```Excalibur::Decorator``` is a
subclass of ```Draper::Decorator``` and comes with the free functionality
provided by [Draper](https://github.com/drapergem/draper). Have fun!

### Configurations

**WARNING:** handle with care!

So you want to roll your own configuration, awesome!
```Excalibur::Configuration``` can be initialized with 3 arguments that are
the title, description and meta tags.

Both title and description are an instance of
```Excalibur::TruncateableContent``` but as long as you make sure a
```.to_s``` with one argument is present for the object you put in there it is
fine. The object passed to it is either a decorated object when it is set or a
blank decorated object.

```Excalibur::TruncateableContent``` can be of course used on it's own when
creating a new configuration. It also takes 3 arguments. Two hashes; the first
for the content and the second for options. On it's own the
TruncateableContent does not do a lot but the third argument takes a
```Proc``` that is called with the decorator on render. By default the proc
combines the content according to the content and the options supplied in the
first two hashes. But of course you can supply your own. Setting them to empty
hashes or nil will work and when merged the default will keep in place.

The meta tags, and third argument of the configuration is a structured hash
with two layers. The first layer is the global type of meta tag and the second
contains the sub-types with the content.

so a meta tag like this:

```html
<meta name="description" content="Excalibur is cool" />
```

you need a hash like this:

```ruby
{
  name: {
    description: 'Excalibur is cool'
  }
}
```

For an OpenGraph tag this would be something like:

```html
<meta property="og:description" content="Excalibur is cool" />
```

```ruby
{
  property: {
    'og:description' => 'Excalibur is cool'
  }
}
```

The content of the meta_tags can be defined as an Array of items or just a
single one. The item itself can be any type of variable that render as a
string on a page. It can also be a ```Proc``` that will be passed the
decorated object just like the title and description. This Proc can also
result in an array.

## Contributing

1. Fork it ( https://github.com/yopefonic/excalibur/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
