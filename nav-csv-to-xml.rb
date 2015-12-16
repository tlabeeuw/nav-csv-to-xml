#!/usr/bin/env ruby

require 'csv'
require 'active_support/all'

navs_for_json = {}
navs_for_xml = []

Dir['navs/*.csv'].each do |csv_file|
  nav = CSV.read(csv_file, headers: true).map(&:to_hash)
  nav_by_parent = nav.group_by { |nav| nav['parent'] }.select { |parent, _| parent }
  nav_by_index = {}
  nav.group_by { |nav| nav['index'] }.each { |index, nav| nav_by_index[index] = nav[0] }
  nav_by_parent.each do |parent, navs|
    nav_by_index[parent]['items'] = navs
  end

  site_name = File.basename(csv_file, '.csv')
  items = nav_by_index.values.select { |nav| nav['parent'].nil? }

  navs_for_json[site_name] = items
  navs_for_xml << { site_name: site_name, items: items}
end

puts navs_for_json
puts navs_for_xml.to_xml(root: 'sites')
