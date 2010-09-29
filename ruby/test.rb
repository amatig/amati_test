#!/usr/bin/env ruby -w

require 'drb'

DRb.start_service
server = DRbObject.new nil, ARGV.shift

puts server.get(0)
