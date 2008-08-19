require File.dirname(__FILE__) + '/spec_helper'

# Warning: these tests will delete all hostnames in the system. Please back them up first

Host.empty!

describe Host, ".list" do
  after(:each) { Host.empty! }
  
  it "should return an array" do
    Host.list.should be_instance_of(Array)
  end
  
  it "should contain instances of Host" do
    Host.add('ghost-test-hostname.local')
    Host.list.first.should be_instance_of(Host)
  end
  
  it "should cache hostname listing" do
    host = 'ghost-test-hostname.local'
    Host.add(host)
    Host.list.should have(1).thing
    `#{Host::CreateCmd % [host, '127.0.0.1']}`
    Host.list.should have(1).thing
  end
  
  it "should not fetch listing from cache if told not to" do
    host = 'ghost-test-hostname.local'
    Host.add(host)
    Host.list.should have(1).thing
    `#{Host::CreateCmd % [host, '127.0.0.1']}`
    Host.list(true).should have(2).thing
  end
end

describe Host do
  after(:each) { Host.empty! }
  
  it "should have an IP" do
    hostname = 'ghost-test-hostname.local'
    
    Host.add(hostname)
    host = Host.list.first
    host.ip.should eql('127.0.0.1')
    
    Host.empty!
    
    ip = '169.254.23.121'
    host = Host.add(hostname, ip)
    host.ip.should eql(ip)
  end
  
  it "should have a hostname" do
    hostname = 'ghost-test-hostname.local'
    
    Host.add(hostname)
    host = Host.list.first
    host.hostname.should eql(hostname)
    
    Host.empty!
    
    ip = '169.254.23.121'
    Host.add(hostname, ip)
    host.hostname.should eql(hostname)
  end
  
  it ".to_s should return hostname" do
    hostname = 'ghost-test-hostname.local'
    
    Host.add(hostname)
    host = Host.list.first
    host.to_s.should eql(hostname)
  end
end

describe Host, "finder methods" do
  after(:all) { Host.empty! }
  before(:all) do
    Host.add('abc.local')
    Host.add('def.local')
    Host.add('efg.local', '10.2.2.4')
  end
  
  it "should return valid Host when searching for host name" do
    Host.find_by_host('abc.local').should be_instance_of(Host)
  end
  
end

describe Host, ".add" do
  after(:each) { Host.empty! }
  
  it "should return Host object when passed hostname" do
    Host.add('ghost-test-hostname.local').should be_instance_of(Host)
  end
  
  it "should return Host object when passed hostname" do
    Host.add('ghost-test-hostname.local', '10.0.0.2').should be_instance_of(Host)
  end
  
  it "should raise error if hostname already exists and not add a duplicate" do
    Host.empty!
    Host.add('ghost-test-hostname.local')
    lambda { Host.add('ghost-test-hostname.local') }.should raise_error
    Host.list.should have(1).thing
  end
  
  it "should overwrite existing hostname if forced" do
    hostname = 'ghost-test-hostname.local'
    
    Host.empty!
    Host.add(hostname)
    
    Host.list.first.hostname.should eql(hostname)
    Host.list.first.ip.should eql('127.0.0.1')
    
    Host.add(hostname, '10.0.0.1', true)
    Host.list.first.hostname.should eql(hostname)
    Host.list.first.ip.should eql('10.0.0.1')
    
    Host.list.should have(1).thing
  end
  
  it "should invalidate the Host.list cache" do
    Host.add('ghost-test-hostname.local')
    Host.list.should have(1).thing
    Host.add('ghost-other-hostname.local')
    Host.list.should have(2).thing # refetched list
  end
end

describe Host, ".empty!" do
  it "should empty the hostnames" do
    Host.add('ghost-test-hostname.local') # add a hostname to be sure
    Host.empty!
    Host.list.should have(0).things
  end
end

describe Host, ".backup and", Host, ".restore" do
  it "should return a yaml file of all hosts and IPs when backing up"
  it "should empty the hosts and restore only the ones in given yaml"
end
