# encoding: utf-8
# copyright: 2016, awim / mtaqwim
# license: All rights reserved

java_path = '/opt/jdk/current'

title 'which(UNIX)/where(Windows) java installed'
control 'java-3.0' do
  impact 0.1
  title 'identify java home'
  desc 'identify java home match to specific path'

  describe java_info(java_path) do
    its(:java_home){ should match java_path}
  end
end