# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module RedHat
        module Bindfs
          class << self
            def bindfs_bindfs_search(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.test('[[ $(yum search bindfs 2>/dev/null | tail -n1) != "No matches found" ]]')
            end

            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('yum -y install bindfs')
            end

            def bindfs_bindfs_search_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                comm.sudo('yum -y install yum-utils')
                comm.execute("repoquery --show-duplicates bindfs-#{version}*  2>/dev/null | head -n1") do |_, output|
                  package_name = output.strip
                  return package_name unless package_name.empty?
                end
              end
              false
            end

            def bindfs_bindfs_install_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              package_name = machine.guest.capability(:bindfs_bindfs_search_version, version)
              machine.communicate.sudo("yum -y install #{package_name.shellescape}")
            end

            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.communicate.sudo('yum -y install make automake gcc gcc-c++ kernel-devel wget tar fuse-devel')
            end
          end
        end
      end
    end
  end
end
