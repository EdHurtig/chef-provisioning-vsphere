require 'chef/provisioning/vsphere_driver'

require_relative 'support/vsphere_helper_stub'

describe ChefProvisioningVsphere::CloneSpecBuilder do
  let(:options) { { host: 'host' } }
  let(:vm_template) { double('template', resourcePool: 'pool') }

  before { allow(vm_template).to receive_message_chain(:config, :guestId) }

  subject do
    builder = ChefProvisioningVsphere::CloneSpecBuilder.new(
      ChefProvisioningVsphereStubs::VsphereHelperStub.new,
      Chef::Provisioning::ActionHandler.new
    )
    builder.build(vm_template, 'machine_name', options)
  end

  context 'using linked clones' do
    before { options[:use_linked_clone] = true }

    it 'sets the disk move type of the relocation spec' do
      expect(subject.location.diskMoveType).to be :moveChildMostDiskBacking
    end
  end

  context 'not using linked clones' do
    before { options[:use_linked_clone] = false }

    it 'sets the disk move type of the relocation spec' do
      expect(subject.location.diskMoveType).to be nil
    end
  end
end