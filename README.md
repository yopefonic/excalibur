# Excalibur

[![Gem Version](https://badge.fury.io/rb/excalibur.svg)](http://badge.fury.io/rb/excalibur)
[![Build Status](https://travis-ci.org/yopefonic/excalibur.svg)](https://travis-ci.org/yopefonic/excalibur)
[![Code Climate](https://codeclimate.com/github/yopefonic/excalibur/badges/gpa.svg)](https://codeclimate.com/github/yopefonic/excalibur)

Excalibur is a SEO related gem for [Ruby on Rails](rubyonrails.org) that helps
you to set the title and meta tags for your site overall and per page in a
nicely structured and with separated concerns.

Setting titles and meta tags for pages can become a hassle when dealing with
more complex SEO requirements. When adding [OpenGraph](http://ogp.me/),
[Twitter Cards](https://dev.twitter.com/cards/overview) or
[schema.org](http://schema.org/docs/gs.html) for Google+ there are a host of
options that differ from object to object. You could add methods to the object
model to create these meta tags but that would put rendering concerns into
model's class. Not an ideal situation. Other option could be to create helper
methods but as you need to present more than 3 different object they can
become cluttered, long and unyielding.

In comes Excalibur; object presentors that have all the logic per object type,
convenient helper methods to print them on the page and an application wide
default configuration.

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

In some cases the object you are trying to ```entitle``` will be of a
different class than you would have the decorator created for. You might work
with single table inheritance or are using sub-classes. In this case you can
pass a ```:class_name``` option. That will be used to find the correct
excalibur decorator in your app.

```ruby
entitle @your_object, class_name: CustomKlass
```

### Views without an object

In some cases you might not have an object to present. Like when on a
collection page or when dealing with a static page. There is a helper method
that allows you to set some custom values. ```quick_set``` takes a couple of
arguments to set the values of titles, descriptions and meta_tags.

These are some examples of what you can set:

```erb
<%
  quick_set :title, :content, :body, 'custom quick set title body'
  quick_set :description, :option, :length, 42
  quick_set :title, :combinator, proc { |obj| custom_code }
  quick_set :meta_tag, :name, :description, 'custom quick set meta tag'
%>
```

### Decorators

The decorators are what turns your object into data that can be used for the
meta tags and the title. So without a decorator for an object the view helper
``` entitle ``` will have no use at all.

To scaffold a decorator execute:

    rails generate excalibur:decorator [class name]

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
