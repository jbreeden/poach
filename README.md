POACH
=====

`poach` packages nashorn projects into executable jar files.

Synopsis
--------

```
poach --name my_app # Creates ./dist/my_app.jar
```


Details
-------

`poach` makes a few assumptions about your project's layout.

1. Your project lives in its own directory, and all files not ending in ".coffee"
   or ".java" within that directory should be packaged into the executable.
2. Any jars you depend on live in the `jars/` folder within your project's root.
   * The contents of these jars are extracted into the executable.
3. The `dist/` folder is reserved for the output of the `poach` command, and so may
   be emptied when `poach` executes.
   * Note that if `dist/` does not exist, `poach` will create it.
4. Your project contains a `main.js` file at its root, which will be loaded when
   the executable is run.
   
As long as your project satisfies these expectations, `poach` will build your
project into an executable jar file. This is accomplished by packaging the project
with a built-in `NashornMain` class whose main method will simply load your `main.js` file.

Example Project Layout
----------------------

```
|- Project/       # The root of your project
   |- dist/       # Poached jar files will end up here
   |- jars/       # Any jar dependencies should be here
   |- com/        # May contain additional .class file dependencies
   |- main.coffee # This file will be ignored. It's for you benefit only.
   |- main.js     # When the jar file is run, this script is loaded
   |- ...         # Any other files or directories required for your app
```

Loading Files in a Jar
----------------------

For nashorn to load your scripts correctly once packaged in a jar, you'll need
to make sure you're referencing them from the classpath. For example, if your project
contains a script file under `path/to/script.js`, your `main.js` file would load it with
the following command:

`load('classpath:path/to/script.js')`

Requirements
------------

To install and run poach, you must have the `ruby` and `jar` commands installed on your system.

Install
-------

From rubygems

```
gem install poach
```

Or, from source

```
gem build poach.gemspec
gem install poach-[CURRENT.VERSION.NUMBER].gem
```

LICENSE
-------

(The MIT License)

Copyright (c) 2014

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
