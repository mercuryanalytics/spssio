# SPSSIO library for Ruby

This project uses FFI to provide a Ruby interface to the IBM SPSS Statistics Input/Output Module,
which allows reading and writing of SPSS SAV files.

* Ruby version

This code is known to run on Ruby 2.5.3, but should work on 2.0 and later.

## System dependencies

The library, as provided by IBM, doesn't quite work right on MacOS. The dynamic libraries
include internal references to each other that require them to be in fixed locations, rather than
in the gem's folder.

I used the following script to "fix" those references, and it's the modified files that
are included in `ext/macos`. Otherwise, the `ext` folder is simply a copy of the IBM-provided
module.

```
# frozen_string_literal: true

# This code is heavily based on https://gist.github.com/matthew-brett/ec2fdd022f478b95ed6d18cf45bc7c62

def install_id(dylib_path)
  `otool -D #{dylib_path}`.split("\n").last
end

def set_install_id(dylib_path, id)
  return unless id

  `install_name_tool -id '#{id}' '#{dylib_path}'`
end

def install_names(dylib_path)
  `otool -L #{dylib_path}`.split("\n").map { |s| s.gsub(/^\t(.*) \(.*\).*$/, '\1') }
end

def set_install_name(dylib_path, old_name, new_name)
  return if new_name.nil? || old_name == new_name

  `install_name_tool -change '#{old_name}' '#{new_name}' '#{dylib_path}'`
end

BAD_START = "@executable_path/../lib/"

def fixed_name(name)
  if name.start_with? BAD_START
    name[BAD_START.size..-1]
  elsif name == "/libzlib1211spss.dylib"
    name[1..-1]
  end
end

def process_dylib(dylib_path)
  iid = install_id(dylib_path)
  new_iid = fixed_name(iid)
  set_install_id(dylib_path, new_iid)

  install_names(dylib_path).each do |install_name|
    new_name = fixed_name(install_name)
    set_install_name(dylib_path, install_name, "@loader_path/#{new_name}") if new_name
  end
end

def dylibs
  base = "lib"
  globber = File.join(base, "*.dylib")
  Dir[globber]
end

dylibs.each do |dylib|
  puts "Processing: #{dylib.inspect}"
  process_dylib(dylib)
end
```

## Using the library

### Reading a SAV file

```
require 'spssio'
require 'csv'

SPSS::Reader.new(ARGV[0]) do |input|
  CSV do |out|
    vars = input.variable_names
    out << vars

    input.each do |case_record|
      out << vars.map { |name| case_record[name] }
    end
  end
end
```
