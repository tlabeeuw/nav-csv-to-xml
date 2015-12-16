#!/usr/bin/env ruby

require 'csv'
require 'active_support/all'

navs = {}

Dir['navs/*.csv'].each do |csv_file|
  nav = CSV.read(csv_file, headers: true).map(&:to_hash)
  nav_by_parent = nav.group_by { |nav| nav['parent'] }.select { |parent, _| parent }
  nav_by_index = {}
  nav.group_by { |nav| nav['index'] }.each { |index, nav| nav_by_index[index] = nav[0] }
  nav_by_parent.each do |parent, navs|
    nav_by_index[parent]['items'] = navs
  end
  navs[File.basename(csv_file, '.csv')] = nav_by_index.values.select { |nav| nav['parent'].nil? }
end

puts navs.to_xml
