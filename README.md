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
   |- main.coffee # This file will be ignored. It's for your benefit only.
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

Subcommands
-----------

The main feature of poach is to package your nashorn app into a jar. This jar will hold not only your scripts, but the contents of any jars you depend on, which can amount to a lot of files. So, if you to extract the contents of your jar to make a quick change to your scripts before repacking it, you would probably see a mess of files rather than your nice clean project structure. Since this is one of the main selling points of working with a scripting language in the first place, poach has a few commands to make this simpler.

To see the available commands, simply run `poach help`

```
Commands:
  poach OPTIONS                # Make executable jar from current directory
  poach extract app.jar regex  # extract all files from jar matching the regex
  poach help [COMMAND]         # Describe available commands or one specific ...
  poach update app.jar glob    # update jar with all files matching the glob
```

`poach extract` takes the name of your jar, and a regex. This will extract any files in the jar with a path that matches the provided regex. In the following example, I've extracted all Javascript and FXML files from a packaged application:

```
C:\equipment-simulator-gui\dist>dir
09/26/2014  07:53 AM           718,239 equipment-simulator-gui.jar
               
C:\equipment-simulator-gui\dist>poach extract equipment-simulator-gui.jar ".*\.(js|fxml)"
Running: jar xf equipment-simulator-gui.jar equipSimController.js
Running: jar xf equipment-simulator-gui.jar fxml/equipSimView.fxml
Running: jar xf equipment-simulator-gui.jar lib/EventEmitter.js
Running: jar xf equipment-simulator-gui.jar lib/fileUtils.js
Running: jar xf equipment-simulator-gui.jar lib/fx.js
Running: jar xf equipment-simulator-gui.jar lib/fx_table.js
Running: jar xf equipment-simulator-gui.jar lib/reconMib.js
Running: jar xf equipment-simulator-gui.jar lib/underscore.js
Running: jar xf equipment-simulator-gui.jar main.js
Running: jar xf equipment-simulator-gui.jar settingsLoader.js
Running: jar xf equipment-simulator-gui.jar SimulatorEventHub.js

C:\equipment-simulator-gui\dist>dir
09/25/2014  06:17 PM           718,239 equipment-simulator-gui.jar
09/25/2014  06:15 PM            15,261 equipSimController.js
09/26/2014  07:46 AM    <DIR>          fxml
09/26/2014  07:46 AM    <DIR>          lib
09/25/2014  06:16 PM               392 main.js
09/25/2014  06:15 PM             2,125 settingsLoader.js
09/25/2014  06:15 PM             2,409 SimulatorEventHub.js
```

You can see that all files ending in .js or .fxml were extracted from the jar, even if they're in subdirectories.

`poach update` takes the name of your jar, and a ruby-style file glob (with support for **). It will then update the jar with all files on the file system matched by the provided glob. In the following example, I've repacked the equipment-simulator-gui app after making changes to the scripts.

```
C:\equipment-simulator-gui\dist>poach update equipment-simulator-gui.jar '**/*.{js,fxml}'
Running: jar uf equipment-simulator-gui.jar equipSimController.js
Running: jar uf equipment-simulator-gui.jar lib/EventEmitter.js
Running: jar uf equipment-simulator-gui.jar lib/fileUtils.js
Running: jar uf equipment-simulator-gui.jar lib/fx.js
Running: jar uf equipment-simulator-gui.jar lib/fx_table.js
Running: jar uf equipment-simulator-gui.jar lib/reconMib.js
Running: jar uf equipment-simulator-gui.jar lib/underscore.js
Running: jar uf equipment-simulator-gui.jar main.js
Running: jar uf equipment-simulator-gui.jar settingsLoader.js
Running: jar uf equipment-simulator-gui.jar SimulatorEventHub.js
Running: jar uf equipment-simulator-gui.jar fxml/equipSimView.fxml
```

Not the use of single quotes. Since I'm running on cmd, this prevents the shell from interpretting my glob and expanding it into parameters to `poach update`.

Requirements
------------

To install and run poach, you must have the `gem` and `jar` commands installed on your system. Usually you'll have both of these already if you have a working installation of Ruby and Java.

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
