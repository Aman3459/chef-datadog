describe 'datadog::system_swap' do
  expected_yaml = <<-EOF
  # Generated by Chef, local modifications will be overwritten

  # This check takes no initial configuration
  init_config:

  instances:
      [{}]
 EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
      node.set['datadog'] = { 'api_key' => 'someapikey' }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('system_swap') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/dd-agent/conf.d/system_swap.yaml')
      .with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
  end
end