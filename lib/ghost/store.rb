class << Ghost
  attr_accessor :store
end

require 'ghost/store/hosts_file_store'
require 'ghost/store/dscl_store' # TODO: only load on OS X

require 'tempfile'
Ghost.store = Ghost::Store::HostsFileStore.new(Tempfile.new('hosts'))

