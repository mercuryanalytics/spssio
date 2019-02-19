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
  Dir[File.join("ext", "macos", "*.dylib")]
end

dylibs.each do |dylib|
  puts "Processing: #{dylib.inspect}"
  process_dylib(dylib)
end
