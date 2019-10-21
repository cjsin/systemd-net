# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

REQUIRED_PLUGINS_LIBVIRT = %w(vagrant-libvirt)

BOX          = 'bento/debian-10'
VAGRANT_HOME = '/home/vagrant'
SRCS         = 'src/'
VAGRANT_SRCS = VAGRANT_HOME + '/src/'

exit unless REQUIRED_PLUGINS_LIBVIRT.all? do |plugin|
    Vagrant.has_plugin?(plugin) || (
        puts "The #{plugin} plugin is required."
        false
    )
end

Vagrant.require_version ">= 2.0.2"

Vagrant.configure("2") do |config|
    config.vm.define "systemd-net"
    config.vm.hostname = "systemd-net"
    config.vm.box = BOX
    config.vm.box_check_update = false

    config.vm.synced_folder './', '/vagrant', type: 'nfs', disabled: true
    #For 9p shares, a mount: false option allows to define synced folders without mounting them at boot.
    config.vm.synced_folder SRCS, VAGRANT_SRCS, type: '9p', disabled: false, accessmode: "mapped" #, owner: "1000"
    #config.vm.synced_folder SRCS, VAGRANT_SRCS, type: '9p', disabled: false, accessmode: "squash", owner: "1000"
    #config.vm.synced_folder SRCS, VAGRANT_SRCS, type: "rsync", rsync__exclude: ".git/"
    #config.vm.synced_folder SRCS, VAGRANT_SRCS, type: '9p', disabled: false, accessmode: "mapped", mount: false

    config.vm.provider "libvirt" do |v|
        v.nic_model_type = 'e1000'
        v.memory         = 1024
        v.graphics_port  = 5901
        v.graphics_ip    = '0.0.0.0'
        v.video_type     = 'qxl'
        v.input :type => "tablet", :bus => "usb"
        v.cpus   = 1
        v.random :model => 'random'
        v.boot 'hd'
        v.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
        v.channel :type => 'spicevmc', :target_name => 'com.redhat.spice.0', :target_type => 'virtio'
    end

   # config.ssh.private_key_path = 'id_rsa'

    config.vm.provision "shell", privileged: true, inline: "/home/vagrant/src/provision.sh"
end
