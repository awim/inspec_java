# encoding: utf-8
# copyright: 2016, awim / mtaqwim
# license: All rights reserved

java_path = '/opt/jdk/current'

title 'which(UNIX)/where(Windows) java installed'
control 'java-2.0' do
  impact 1.0
  title 'run java from specific path'
  desc 'run java from specific path'

  describe java_info(java_path) do
    it{ should exist }
    its(:version){ should match '1.7'}
  end
end